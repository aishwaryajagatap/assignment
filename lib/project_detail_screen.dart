// ignore_for_file: prefer_const_constructors

import 'package:assignment/Images/image_screen.dart';
import 'package:assignment/Images/video_screen.dart';
import 'package:assignment/models/project_model.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          project.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF07429E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Manage Project Media',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Image Upload Section
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ImagesSreen(projectId: project.id)),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.image, size: 40, color: Color(0xFF07429E)),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Images',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Upload or view project-related images'),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF07429E)),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Video Upload Section
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => VideosScreen(projectId: project.id)),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.video_library,
                          size: 40, color: Color(0xFF07429E)),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Videos',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Upload or view project-related videos'),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Color(0xFF07429E)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
