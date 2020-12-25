import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/constants.dart';
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

  buildField(String text, TextField textFieldFunction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(7, 12, 0, 0),
          child: Text(
            text.toUpperCase(),
            style: kTextHeaderTextFields),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
          child: textFieldFunction,
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
      'why': '',
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
                      buildField(
                          "Bio", multilineTextField('Bio', bioController)),
                      buildField("Contact",
                          multilineTextField('Contact', contactController)),
                      buildField(
                          "Name", singlelineTextField('Name', nameController)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0,
                            MediaQuery.of(context).viewInsets.bottom),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            elevation: MaterialStateProperty.all(0.0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            side: MaterialStateProperty.all(
                              BorderSide(color: Colors.black),
                            ),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(0.0)),
                          ),
                          onPressed: createProject,
                          child: Text(
                            'SAVE',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0,
                            MediaQuery.of(context).viewInsets.bottom),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            elevation: MaterialStateProperty.all(0.0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            side: MaterialStateProperty.all(
                              BorderSide(color: Colors.black),
                            ),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(0.0)),
                          ),
                          onPressed: cancelUpdate,
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              'CANCEL',
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
