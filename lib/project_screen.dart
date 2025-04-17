// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:assignment/maps/chart_screen.dart';
import 'package:assignment/maps/maps_screen.dart';
import 'package:assignment/models/project_model.dart';
import 'package:assignment/project_detail_screen.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/services/firestore_service.dart';
import 'package:flutter/material.dart';

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  // List to hold all the projects
  List<ProjectModel> allProjects = [];
  // List to hold filtered projects based on search query
  List<ProjectModel> filteredProjects = [];
  // Controller for search field
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load projects when the screen is initialized
    loadProjects();
  }

  // Method to load projects from Firestore service
  void loadProjects() async {
    final projects = await FirestoreService().getProjects();
    if (!mounted) return;

    setState(() {
      allProjects.clear();
      filteredProjects.clear();
      allProjects = projects;
      filteredProjects = projects;
    });
  }

  // Method to filter projects based on search query
  void filterProjects(String query) {
    final filtered = allProjects
        .where((proj) => proj.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() => filteredProjects = filtered);
  }

  // Method to handle user logout
  void logout() => AuthService.logout(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App bar with title and logout icon
        title: const Text("Projects", style: TextStyle(color: Colors.white)),
        actions: [
          // Logout button that calls logout method when pressed
          IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: logout),
        ],
        backgroundColor: Color(0xFF07429E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with the title 'View Maps and Chart'
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF07429E),
              ),
              child: Text(
                'View Maps and Chart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // ListTile for navigating to the MapScreen
            ListTile(
              leading:
                  Icon(Icons.location_on, color: Color(0xFF07429E), size: 30),
              title: Text('View Map', style: TextStyle(fontSize: 17)),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MapScreen()));
              },
            ),
            // ListTile for navigating to the ChartPage
            ListTile(
              leading:
                  Icon(Icons.show_chart, color: Color(0xFF07429E), size: 30),
              title: Text('View Chart', style: TextStyle(fontSize: 17)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChartPage()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search field to search through projects
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchCtrl,
              onChanged: filterProjects,
              decoration: InputDecoration(
                hintText: "Search projects...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          // Display filtered projects or show a message if no projects are found
          Expanded(
            child: filteredProjects.isEmpty
                ? const Center(
                    child: Text(
                    "No matching projects found.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ))
                : ListView.builder(
                    itemCount: filteredProjects.length,
                    itemBuilder: (_, i) {
                      final project = filteredProjects[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: GestureDetector(
                          // Navigate to ProjectDetailScreen when tapped
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProjectDetailScreen(project: project),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.folder,
                                  color: Colors.blueAccent, size: 30),
                              title: Text(
                                project.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 18, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
