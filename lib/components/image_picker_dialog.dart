import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ImagePickerDialog {
  final BuildContext context;
  final List<File> selectedFiles;

  ImagePickerDialog(this.context, this.selectedFiles);

  Future<void> showImagePickerDialog(
      Function(List<File>) onFilesSelected) async {
    await requestPermissions();
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               GestureDetector(
              onTap: () {
                print("click");
                context.pop();
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: SizedBox(
                  width: 100,
                  child: Divider(
                    thickness: 3.0,
                  ),
                ),
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/listing/add_media.png",
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add image or video',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: theme.colorScheme.onSurface,
                                  )),
                              Text(
                                "Upload from media or use camera",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading:  Icon(CupertinoIcons.photo,
                            color: theme.colorScheme.primary),
                title: const Text('Upload from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _openGallery(onFilesSelected);
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.camera,
                            color: theme.colorScheme.primary),
                title: const Text('Use Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _showCameraOptions(onFilesSelected);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openGallery(Function(List<File>) onFilesSelected) async {
    try {
      List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          requestType: RequestType.all,
        ),
      );
      if (result != null && result.isNotEmpty) {
        List<File> selectedFiles = [];
        for (var asset in result) {
          final file = await asset.file;
          if (file != null) {
            selectedFiles.add(file);
          }
        }
        onFilesSelected(selectedFiles);
      }
    } catch (e) {
      print('Error opening gallery: $e');
      // Handle error accordingly, e.g., show a snackbar or alert dialog
    }
  }

  void _showCameraOptions(Function(List<File>) onFilesSelected) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? picture = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    preferredCameraDevice: CameraDevice.rear,
                  );
                  if (picture != null) {
                    onFilesSelected([File(picture.path)]);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Record a Video'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? video = await ImagePicker().pickVideo(
                    source: ImageSource.camera,
                    preferredCameraDevice: CameraDevice.rear,
                  );
                  if (video != null) {
                    onFilesSelected([File(video.path)]);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted &&
          await Permission.camera.request().isGranted) {
        // Permissions are granted
      } else {
        // Permissions are denied, handle accordingly
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted &&
          await Permission.camera.request().isGranted) {
        // Permissions are granted
      } else {
        // Permissions are denied, handle accordingly
      }
    }
  }
}
