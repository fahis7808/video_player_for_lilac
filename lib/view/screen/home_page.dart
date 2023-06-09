import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player_for_lilac/model/video_model.dart';
import 'package:video_player_for_lilac/provider/home_page_provider.dart';

import '../widget/drawer.dart';
import '../widget/video_player.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageProvider(),
      child: Consumer<HomePageProvider>(builder: (context, data, _) {
        File? files;
        return Scaffold(
          appBar: AppBar(title: const Text('Home Page')),
          drawer: const AppDrawer(),
          body: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      data.controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: data.controller.value.aspectRatio,
                              child: Chewie(
                                controller: data.chewieController,
                              ),
                            )
                          : const CircularProgressIndicator(),
                      Positioned(
                          bottom: 33,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 70,),
                                IconButton(
                                    onPressed: () {
                                      data.goToPrevious();
                                    },
                                    icon: const Icon(
                                      Icons.skip_next_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                IconButton(
                                  icon: const Icon(Icons.fast_rewind),
                                  onPressed: data.rewind,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.fast_forward),
                                  onPressed: data.fastForward,
                                ),
                                IconButton(
                                    onPressed: () {
                                      data.goToNext();
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                              ],
                            ),
                          )),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: videoList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Row(
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  videoList[index].thumbnailUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                videoList[index].name,
                                style: TextStyle(
                                    color: context.theme.colorScheme.primary),
                              ),
                            ],
                          ),
                          onTap: () {
                            data.playVideo(index: index);
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen()));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: ElevatedButton(
            onPressed: () async {
              final file =
                  await ImagePicker().pickVideo(source: ImageSource.gallery);
              if (file != null) {
                files = File(file.path);
                data.refresh();
              }

              if (files != null) {
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LocalVideoPlayer(
                            url: files?.path.toString() ?? "")));
              }
            },
            child: const Text(
              'Video From Gallery',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButton: data.progressValue != null
              ? const CircularProgressIndicator()
              : FloatingActionButton(
                  backgroundColor: context.theme.colorScheme.primary,
                  onPressed: () {
                    data.videoDownload();
                  },
                  child: const Icon(Icons.download),
                ),
        );
      }),
    );
  }
}
