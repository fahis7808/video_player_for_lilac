import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_for_lilac/model/user_model.dart';
import 'package:video_player_for_lilac/model/video_model.dart';

class HomePageProvider extends ChangeNotifier {
  UserModel? userModel;

  String? uid;

  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  bool showMode = false;

  bool? switchValue;

  double? progressValue;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  onSettings() {
    showMode = !showMode;
    notifyListeners();
  }

  HomePageProvider() {
    getDataFromSP();
    // videoPlayerProvider();
    playVideo(init: true);
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    userModel = UserModel.fromMap(jsonDecode(data));
    uid = userModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
    SystemNavigator.pop();
    notifyListeners();
  }

  VideoPlayerController? _controller;

  VideoPlayerController get controller => _controller!;

  ChewieController? _chewieController;

  ChewieController get chewieController => _chewieController!;

  int currentIndex = 0;

  void playVideo({int index = 0, bool init = false}) {
    if (index < 0 || index >= videoList.length) return;

    if (!init) {
      _controller?.pause();
      notifyListeners();
    }
    currentIndex = index;
    notifyListeners();

    _controller =
        VideoPlayerController.network(videoList[currentIndex].videoUrl)
          ..addListener(() {
            notifyListeners();
          })
          ..setLooping(true)
          ..initialize().then((value) => _controller?.pause());
    _chewieController = ChewieController(
        videoPlayerController: _controller!,
      autoPlay: true,
      looping: false,
    );
  }

  void goToNext() {
    if (currentIndex < videoList.length - 1) {
      currentIndex++;
      playVideo(index: currentIndex);
      notifyListeners();
    }
  }

  void goToPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
      playVideo(index: currentIndex);
      notifyListeners();
    }
  }
  void fastForward() {
    final controller = chewieController.videoPlayerController;
    final duration = controller.value.duration;
    final currentPosition = controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    if (newPosition < duration) {
      controller.seekTo(newPosition);
    }
  }

  void rewind() {
    final controller = chewieController.videoPlayerController;
    final currentPosition = controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    if (newPosition >= Duration.zero) {
      controller.seekTo(newPosition);
    }
  }

  videoDownload() async {
    final File? file = await FileDownloader.downloadFile(
        url: videoList[currentIndex].videoUrl,
        name: videoList[currentIndex].name,
        onProgress: (String? fileName, double progress) {
          progressValue = progress;
        },
        onDownloadCompleted: (String path) {
          progressValue = null;
        },
        onDownloadError: (String error) {

        });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  refresh() {
    notifyListeners();
  }
}
