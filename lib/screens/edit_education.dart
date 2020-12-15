import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/education.dart';
import 'package:reachout/models/users.dart';

class EditEducation extends StatefulWidget {
  final String profileId;

  EditEducation({this.profileId});
  @override
  _EditEducationState createState() => _EditEducationState();
}

class _EditEducationState extends State<EditEducation> {
  TextEditingController titleController = TextEditingController();
  TextEditingController instituteController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController activeController = TextEditingController();
  bool isLoading;
  List<dynamic> educations;
  User user;

  cancelUpdate() {
    Navigator.of(context).pop();
  }

  buildField(String head, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 12,
          ),
          child: Text(
            head,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Update Data",
          ),
        ),
      ],
    );
  }

  activeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            "Active",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          enabled: false,
          controller: activeController,
          decoration: InputDecoration(
            hintText: "Update Data",
          ),
        ),
      ],
    );
  }

  updateProfileData() async {
    Education education = Education(
      institute: instituteController.text,
      title: titleController.text,
      description: descriptionController.text,
      date: dateController.text,
    );
    DocumentSnapshot doc = await usersRef.document(widget.profileId).get();
    user = User.fromDocument(doc);
    educations = user.educations;
    educations.add(education.toMap());
    usersRef.document(widget.profileId).updateData({
      'educations': educations,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(currentUser.photoUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      buildField('Title', titleController),
                      buildField('Institute', instituteController),
                      buildField('Description', descriptionController),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: updateProfileData,
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: cancelUpdate,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
