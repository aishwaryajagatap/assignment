// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class ImagesSreen extends StatefulWidget {
  final String projectId;
  ImagesSreen({super.key, required this.projectId});

  @override
  _ImagesSectionState createState() => _ImagesSectionState();
}

class _ImagesSectionState extends State<ImagesSreen> {
  List<File> imageFiles = [];

  @override
  void initState() {
    super.initState();
    loadImages(); // Call loadImages to load previously saved images
  }

  // Method to get the folder path for saving and accessing images of a specific project
  Future<String> _getProjectFolderPath() async {
    final dir =
        await getApplicationDocumentsDirectory(); // Get app's document directory
    final projectFolder =
        Directory('${dir.path}/projects/${widget.projectId}/images');

    // Create the directory if it doesn't exist
    if (!await projectFolder.exists()) {
      await projectFolder.create(recursive: true);
    }

    return projectFolder.path; // Return the folder path
  }

  // Method to load the images from the project's folder and update the UI
  Future<void> loadImages() async {
    final path = await _getProjectFolderPath(); // Get the folder path
    final files = Directory(path)
        .listSync()
        .whereType<File>()
        .toList(); // List all files in the directory

    setState(
        () => imageFiles = files); // Update the state to display the images
  }

  // Method to show a dialog allowing the user to choose between camera and gallery
  Future<void> _showPickerOptions() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt), // Camera icon
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                _pickImage(ImageSource.camera); // Pick image from camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo), // Gallery icon
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                _pickImage(ImageSource.gallery); // Pick image from gallery
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to pick an image from the specified source (camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source); // Pick image

      if (pickedFile != null) {
        final path =
            await _getProjectFolderPath(); // Get the project folder path
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}.jpg'; // Generate a unique file name
        final savedFile = await File(pickedFile.path)
            .copy('$path/$fileName'); // Save the image

        setState(() => imageFiles
            .add(savedFile)); // Update the state to display the new image
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error picking image: $e"')));
    }
  }

  // Method to download the image to the device's storage
  Future<void> downloadImage(File file) async {
    try {
      if (Platform.isAndroid) {
        // For Android 10 and below
        if (await Permission.storage.request().isGranted) {
          await _saveImageToDownloads(
              file); // Save image to the Downloads folder
        }
        // For Android 11+ (API 30+)
        else if (await Permission.manageExternalStorage.request().isGranted) {
          await _saveImageToDownloads(
              file); // Save image to the Downloads folder
        } else {
          if (await Permission.storage.isPermanentlyDenied ||
              await Permission.manageExternalStorage.isPermanentlyDenied) {
            _showPermissionSettingsDialog(); // Show settings dialog if permissions are permanently denied
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image: ${e.toString()}')),
      );
    }
  }

  // Helper method to save the image to the device's Downloads directory
  Future<void> _saveImageToDownloads(File file) async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory(
          '/storage/emulated/0/Download'); // Android Download directory
      if (!await directory.exists()) {
        directory =
            await getExternalStorageDirectory(); // Fallback if the Downloads directory doesn't exist
      }
    }

    if (directory != null) {
      final fileName = p.basename(file.path); // Get the file name
      final newPath =
          '${directory.path}/$fileName'; // Create new path for the saved image
      await file.copy(newPath); // Save the image

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to ${directory.path}')),
      );
    }
  }

  // Method to show a dialog requesting the user to enable storage permissions
  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'To save images, please grant storage permissions in app settings. '
            'Go to Settings > Apps > [Your App Name] > Permissions and enable Storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Open app settings to enable permissions
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Images",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF07429E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPickerOptions,
        child: const Icon(
          Icons.add_a_photo,
          color: Color(0xFF07429E),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: imageFiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (_, i) {
          return GestureDetector(
            onLongPress: () => downloadImage(imageFiles[i]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageViewerPage(
                      imageFile: imageFiles[i]), // View full-size image
                ),
              );
            },
            child: Stack(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(imageFiles[i],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity),
                ),
                Positioned(
                  bottom: 4,
                  left: 4,
                  right: 4,
                  child: Container(
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    child: const Text(
                      "Long press to download",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ImageViewerPage extends StatelessWidget {
  final File imageFile;

  const ImageViewerPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0, // Allow zooming in/out of the image
          child: Image.file(imageFile), // Display the image
        ),
      ),
    );
  }
}
