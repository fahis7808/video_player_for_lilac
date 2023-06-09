import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player_for_lilac/model/user_model.dart';
import 'package:video_player_for_lilac/util/snackBar.dart';
import 'package:video_player_for_lilac/util/uploade_image.dart';
import 'package:video_player_for_lilac/view/screen/home_page.dart';
import 'package:video_player_for_lilac/view/screen/verify_page.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  bool _loaded = false;

  bool get isLoaded => _loaded;

  String? _uid;

  String get uid => _uid.toString();

  UserModel? _userModel;

  UserModel get userModel => _userModel!;

  String phoneCode = '+91';
  int? phone;

  String? smsCode;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  File? image;
  String? name;
  String? email;
  String? pickedDate;

  // FirebaseFireStore firebaseFireStore = Firebase

  AuthenticationProvider() {
    signInCheck();
  }

  signInCheck() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _isSignedIn = sharedPreferences.getBool('is_signedin') ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  signInWithPhone(BuildContext context) async {
    String phoneNumber = phone.toString().trim();
    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneCode + phoneNumber.toString(),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            showSnackBar(context, error.message.toString());
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyPage(
                          verificationId: verificationId,
                        )));
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    }
  }

  onRefresh() {
    notifyListeners();
  }

  verifyOtp(
      {required BuildContext context, required String verificationId}) async {
    _loaded = true;
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode.toString());
      User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      if (user != null) {
        _uid = user.uid;
        checkExistingUser().then((value) async {
          if (value == true) {
            getDataFromFireStore().then((value) => saveUserDataSP().then(
                (value) => setSignIn().then((value) =>
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'homePage', (route) => false))));
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, 'register', (route) => false);
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<bool> checkExistingUser() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: _uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      pickedDate = formattedDate.toString();
      notifyListeners();
    }

    return picked;
  }

  selectImage(BuildContext context) async {
    image = await pickImage(context);
    notifyListeners();
  }

  registerData(BuildContext context) async {
    UploadTask uploadTask =
        firebaseStorage.ref().child('profilePic/$_uid').putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    UserModel userModel = UserModel(
        name: name.toString(),
        email: email.toString(),
        profilePic: downloadUrl,
        dob: pickedDate.toString(),
        createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
        phoneNumber: firebaseAuth.currentUser!.phoneNumber!,
        uid: firebaseAuth.currentUser!.uid);
    if (image != null) {
      // ignore: use_build_context_synchronously
      saveUserDataToFirebase(
          context: context,
          userModel: userModel,
          profilePic: image!,
          onSuccess: () {
            saveUserDataSP().then(
              (value) => setSignIn().then(
                (value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                    (route) => false),
              ),
            );
          });
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Please Add an Image');
    }
  }

  saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _loaded = true;
    notifyListeners();

    try {
      storeFiletToStorage('profilePic/$_uid', profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().microsecondsSinceEpoch.toString();
        userModel.phoneNumber = firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = firebaseAuth.currentUser!.uid;
      });

      _userModel = userModel;
      await firebaseStore
          .collection('users')
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _loaded = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      _loaded = false;
      showSnackBar(context, e.toString());
      notifyListeners();
    }
  }

  Future<String> storeFiletToStorage(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future saveUserDataSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'user_model', jsonEncode(userModel.toMap()));
  }

  Future<void> getDataFromFireStore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: _uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs[0].data() as Map<String, dynamic>;

      _userModel = UserModel(
        name: data['name'],
        email: data['email'],
        profilePic: data['profilePic'],
        dob: data['dob'],
        createdAt: data['createdAt'],
        phoneNumber: data['phoneNumber'],
        uid: data['uid'],
      );

      _uid = _userModel?.uid;
    } else {
    }
  }


 /* getDataFromFireStore() async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .get();
    if (snapshot.exists) {
      _userModel = UserModel(
        name: snapshot.data()?['name'],
        email: snapshot.data()['email'],
        profilePic: snapshot.data()['profilePic'],
        dob: snapshot.data()['dob'],
        createdAt: snapshot.data()['createdAt'],
        phoneNumber: snapshot.data()['phoneNumber'],
        uid: snapshot.data()['uid'],
      );
      _uid = _userModel?.uid;
    } else {
      print('User document does not exist');
    }
  }*/

/*  Future getDataFromFireStore() async {
    print('getdatafromfirestore -- -- -- - ');
    await firebaseStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
          name: snapshot['name'],
          email: snapshot['email'],
          profilePic: snapshot['profilePic'],
          dob: snapshot['dob'],
          createdAt: snapshot['createdAt'],
          phoneNumber: snapshot['phoneNumber'],
          uid: snapshot['uid']);
      _uid = userModel.uid;
    });
  }*/

  Future getDataFromSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    sharedPreferences.clear();
  }
}
