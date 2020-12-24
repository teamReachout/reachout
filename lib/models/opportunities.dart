import 'package:cloud_firestore/cloud_firestore.dart';

class Opportunities {
  final String name;
  final String description;
  final String link;

  Opportunities({
    this.name,
    this.description,
    this.link,
  });

  factory Opportunities.fromDocument(DocumentSnapshot doc) {
    return Opportunities(
      name: doc['name'],
      description: doc['description'],
      link: doc['link'],
    );
  }
}
