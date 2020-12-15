import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String number;
  final String dateOfBirth;
  final String role;
  final String email;
  final String photoUrl;
  final String bio;
  final List<dynamic> areaOfWork;
  final List<dynamic> experiences;
  final List<dynamic> educations;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.number,
    this.role,
    this.email,
    this.photoUrl,
    this.bio,
    this.areaOfWork,
    this.experiences,
    this.educations,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
      number: doc['number'],
      dateOfBirth: doc['dateofbirth'],
      role: doc['role'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
      areaOfWork: doc['areaOfWork'],
      experiences: doc['experiences'],
      educations: doc['educations'],
    );
  }
}
