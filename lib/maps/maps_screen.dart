// map_screen.dart
import 'package:assignment/project_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<ProjectModel> projects = [];

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('projects').get();

    final loadedProjects = snapshot.docs
        .map((doc) => ProjectModel.fromFirestore(doc.data(), doc.id))
        .toList();

    setState(() => projects = loadedProjects);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Map", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF07429E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: projects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter:
                    LatLng(projects.first.latitude, projects.first.longitude),
                maxZoom: 5,
                minZoom: 2,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.projectmap',
                ),
                MarkerLayer(
                  markers: projects.map((project) {
                    return Marker(
                      width: 40,
                      height: 40,
                      point: LatLng(project.latitude, project.longitude),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProjectDetailScreen(project: project),
                            ),
                          );
                        },
                        child: const Icon(Icons.location_on,
                            size: 40, color: Colors.red),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}
