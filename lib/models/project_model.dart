class ProjectModel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final int startYear;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.startYear
  });

  factory ProjectModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProjectModel(
      id: id,
      name: data['name'] ?? "",
      description: data['description'] ?? "",
      latitude: data['latitude'] ?? "",
      longitude: data['longitude'] ?? "",
      startYear: data['startYear'] ?? ""
    );
  }
}
