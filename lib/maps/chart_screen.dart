// ignore_for_file: avoid_print

import 'package:assignment/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  
  List<ProjectModel> projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('projects').get();

      final loadedProjects = snapshot.docs
          .map((doc) => ProjectModel.fromFirestore(doc.data(), doc.id))
          .toList();

      setState(() {
        projects = loadedProjects;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching projects: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Projects Chart', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF07429E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : projects.isEmpty
              ? const Center(child: Text('No projects found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Project Start Years',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF07429E),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: ResponsiveLineChart(projects: projects),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class ResponsiveLineChart extends StatelessWidget {
  final List<ProjectModel> projects;

  const ResponsiveLineChart({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final startYears = projects.map((e) => e.startYear).toSet().toList()..sort();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (projects.length - 1).toDouble(),
        minY: startYears.first.toDouble() - 1,
        maxY: startYears.last.toDouble() + 1,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < projects.length) {
                  // Split project name into two lines
                  String name = projects[index].name;
                  List<String> words = name.split(' ');
                  String firstLine = words.length > 1 ? words.sublist(0, (words.length / 2).ceil()).join(' ') : name;
                  String secondLine = words.length > 1 ? words.sublist((words.length / 2).ceil()).join(' ') : '';

                  return Transform.translate(
                    offset: const Offset(0, 10),
                    child: Text(
                      '$firstLine\n$secondLine',
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (startYears.contains(value.toInt())) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              interval: 1,
              reservedSize: 40,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              projects.length,
              (index) => FlSpot(index.toDouble(), projects[index].startYear.toDouble()),
            ),
            isCurved: true,
            color: const Color(0xFF07429E),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF07429E).withOpacity(0.1),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: const Color(0xFF07429E),
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

