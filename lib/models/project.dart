import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String name;
  final String contact;
  final String photoUrl;
  final String bio;
  final List<dynamic> areaOfWork;
  final List<dynamic> founders;
  final List<dynamic> collaborators;

  Project({
    this.id,
    this.name,
    this.contact,
    this.photoUrl,
    this.bio,
    this.areaOfWork,
    this.founders,
    this.collaborators,
  });

  factory Project.fromDocument(DocumentSnapshot doc) {
    return Project(
      id: doc['id'],
      contact: doc['contact'],
      name: doc['name'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
      areaOfWork: doc['areaOfWork'],
      founders: doc['founders'],
      collaborators: doc['collaborators'],
    );
  }
}
