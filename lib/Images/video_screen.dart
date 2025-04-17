// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'dart:io';
import 'package:assignment/Images/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class VideosScreen extends StatefulWidget {
  final String projectId;
  // Constructor receiving a project ID to determine the storage path for videos
  VideosScreen({required this.projectId});

  @override
  _VideosSectionState createState() => _VideosSectionState();
}

class _VideosSectionState extends State<VideosScreen> {
  List<File> videoFiles = [];

  @override
  void initState() {
    super.initState();
    loadVideos(); // Load existing videos when the widget initializes
  }

// Returns the directory path for storing videos of a particular project
  Future<String> _getProjectFolderPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final projectFolder =
        Directory('${dir.path}/projects/${widget.projectId}/videos');
    if (!await projectFolder.exists()) {
      await projectFolder.create(recursive: true);
    }
    return projectFolder.path;
  }

  // Loads all video files from the project folder and updates the UI
  Future<void> loadVideos() async {
    final path = await _getProjectFolderPath();
    final files = Directory(path).listSync().whereType<File>().toList();
    setState(() => videoFiles = files);
  }

  // Allows the user to pick a video from the gallery and saves it to the project folder
  Future<void> pickAndSaveVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);

    if (picked != null) {
      final path = await _getProjectFolderPath();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      final savedFile = await File(picked.path).copy('$path/$fileName');
      setState(() => videoFiles.add(savedFile));
    }
  }

// Downloads the selected video to the Downloads folder after requesting permission
  Future<void> downloadVideo(File file) async {
    final permission = await Permission.manageExternalStorage.request();

    if (permission.isGranted) {
      final downloads = Directory('/storage/emulated/0/Download');
      final fileName = p.basename(file.path);
      final newFile = File('${downloads.path}/$fileName');

      await newFile.writeAsBytes(await file.readAsBytes());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video saved to Downloads')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to save video was denied')),
      );
      await openAppSettings(); // opens app settings to manually enable
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Videos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF07429E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickAndSaveVideo,
        child: const Icon(
          Icons.video_library,
          color: Color(0xFF07429E),
        ),
      ),
      body: ListView.builder(
        itemCount: videoFiles.length,
        itemBuilder: (_, i) {
          return GestureDetector(
            onLongPress: () {
              downloadVideo(videoFiles[i]);
            },
            child: Card(
              child: Column(
                children: [
                  Text("Video ${i + 1} (Long press to download)"),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayerWidget(url: videoFiles[i].path),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
