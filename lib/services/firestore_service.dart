import 'package:assignment/models/project_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ProjectModel>> getProjects() async {
    final snapshot = await _db.collection('projects').get();
    return snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc.data(), doc.id)).toList();
  }
}
