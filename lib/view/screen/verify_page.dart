import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:video_player_for_lilac/provider/authentication_provider.dart';
import 'package:video_player_for_lilac/util/snackBar.dart';

class VerifyPage extends StatelessWidget {
final String verificationId;
  const VerifyPage({Key? key, required this.verificationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(),
      child: Consumer<AuthenticationProvider>(builder: (context, data, _) {
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   Text(
                    "We need to register your phone without getting started!",
                    style: context.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    onChanged: (val) {
                      data.smsCode = val;
                      data.onRefresh();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: context.theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          if(data.smsCode != null){
                            data.verifyOtp(context:context, verificationId: verificationId);
                          }else{
                           showSnackBar(context, 'Please enter OTP');
                          }
                        },
                        child:  Text(
                          "Verify Phone Number",
                          style: TextStyle(color:context.theme.colorScheme.background),
                        )),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              'login',
                              (route) => false,
                            );
                          },
                          child:  Text(
                            "Edit Phone Number ?",
                            style: TextStyle(color: context.theme.colorScheme.onBackground),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

}
