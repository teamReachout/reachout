import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/project.dart';
import 'package:uuid/uuid.dart';

class CreateProjectPage extends StatefulWidget {
  final String profileId;

  CreateProjectPage({this.profileId});
  @override
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  TextEditingController bioController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String projectId = Uuid().v4();
  bool isLoading;
  Project user;

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
            hintText: "Data",
          ),
        ),
      ],
    );
  }

  cancelUpdate() {
    Navigator.of(context).pop();
  }

  createProject() {
    projectRef
        .document(widget.profileId)
        .collection('userProject')
        .document(projectId)
        .setData({
      'id': projectId,
      'name': nameController.text,
      'contact': contactController.text,
      'photoUrl': '',
      'bio': bioController.text,
      'areaOfWork': [],
      'founders': [currentUser.id],
      'collaborators': [],
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
                Text(
                  "New Project",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      buildField("Bio", bioController),
                      buildField("Contact", contactController),
                      buildField("Name", nameController)
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: createProject,
                  child: Text(
                    'Create',
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
