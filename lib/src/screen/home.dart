import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/components/image_picker_dialog.dart';
import 'package:video_player/src/video_player/video_media.dart';
import 'package:video_player/src/video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> images = [];
  void handlePress(List<File> selectedFiles) async {
    ImagePickerDialog imagePickerDialog = ImagePickerDialog(context, images);

    imagePickerDialog.showImagePickerDialog((List<File> selectedFiles) async {
      setState(() {
        images.addAll(selectedFiles);
        print("Image List $images");
      });
    });
  }

  void showImageOrVideoDialog(File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (isVideo(file)) {
          return VideoDialog(file: file);
        } else {
          return Dialog(
            child: Image.file(
              file,
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }

  bool isVideo(File file) {
    final videoExtensions = [
      '.gif',
      '.bmp',
      '.tiff',
      '.webp',
      '.mp4',
      '.avi',
      '.mov',
      '.mkv',
      '.wmv',
      '.flv',
      '.mpeg',
      '.mpeg-4',
      '.mp3',
      '.wav',
      '.ogg',
      '.flac',
      '.MOV',
      'HEVC',
      '.3gp',
      '.m4v',
      '.webm',
      '.ogv',
      '.ts',
      '.vob',
      '.rm',
      '.rmvb',
    ];
    return videoExtensions.any((ext) => file.path.endsWith(ext));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    handlePress(images);
                  },
                  child: DottedBorder(
                    color: Colors.purple,
                    radius: const Radius.circular(12),
                    borderType: BorderType.RRect,
                    strokeWidth: 2,
                    dashPattern: const <double>[8, 4],
                    child: Container(
                      alignment: Alignment.center,
                      height: Platform.isAndroid ? 92 : 94,
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.camera,
                            size: 32,
                            color: Colors.purple
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                            child: Text(
                              "Add Photo/Video",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:  Colors.purple,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                for (var image in images)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => showImageOrVideoDialog(image),
                      child: isVideo(image)
                          ? VideoThumbnail(file: image)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
