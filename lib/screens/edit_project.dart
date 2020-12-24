import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/models/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProject extends StatefulWidget {
  final String projectId;

  EditProject({this.projectId});
  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController whyController = TextEditingController();
  bool isLoading;
  User user;

  buildField(String text, TextField textFieldFunction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(7, 12, 0, 0),
          child: Text(text.toUpperCase(), style: kTextHeaderTextFields),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
          child: textFieldFunction,
        )
      ],
    );
  }

  cancelUpdate() {
    Navigator.of(context).pop();
  }

  updateProfileData() {
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
    if (emailController.text.trim() != '') {
      projectRef
          .document(currentUser.id)
          .collection('userProject')
          .document(widget.projectId)
          .updateData({
        "why": whyController.text,
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              buildField(
                "Bio",
                multilineTextField('Bio', bioController),
              ),
              buildField(
                "Email",
                singlelineTextField('Email', emailController),
              ),
              buildField(
                "Why we started",
                multilineTextField('Your Story', whyController),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, 0.0, 10.0, MediaQuery.of(context).viewInsets.bottom),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(0.0),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.black),
                ),
                padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
              ),
              onPressed: updateProfileData,
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
        )
      ],
    );
  }
}
