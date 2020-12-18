import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';

class EditProject extends StatefulWidget {
  final String projectId;

  EditProject({this.projectId});
  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading;
  User user;

  buildField(String text, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            text,
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

  cancelUpdate() {
    Navigator.of(context).pop();
  }

  updateProfileData() {
    // print(widget.projectId);
    projectRef
        .document(currentUser.id)
        .collection('userProject')
        .document(widget.projectId)
        .updateData({
      "bio": bioController.text,
    });
    if (emailController.text.trim() != '') {
      projectRef
          .document(currentUser.id)
          .collection('userProject')
          .document(widget.projectId)
          .updateData({
        "email": emailController.text,
      });
    }
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
                      buildField("Bio", bioController),
                      buildField("Email", emailController),
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
