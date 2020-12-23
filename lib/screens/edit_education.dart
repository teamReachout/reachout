import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/constants.dart';
import 'package:reachout/models/education.dart';
import 'package:reachout/models/users.dart';
import 'package:google_fonts/google_fonts.dart';

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

  buildField(String head, TextField textFieldFunction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(7, 12, 0, 0),
          child: Text(head.toUpperCase(), style: kTextHeaderTextFields),
        ),
        Padding(
          padding: EdgeInsets.only(top: 7.0),
          child: textFieldFunction,
        )
        // TextField(
        //   controller: controller,
        //   decoration: InputDecoration(
        //     hintText: "Update Data",
        //   ),
        // ),
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
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Padding(
          //   padding: EdgeInsets.only(
          //     top: 16,
          //     bottom: 8,
          //   ),
          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundImage: NetworkImage(currentUser.photoUrl),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                buildField(
                    'Title', singlelineTextField('Title', titleController)),
                buildField('Institute',
                    singlelineTextField('Title', instituteController)),
                buildField('Description',
                    multilineTextField('Description', descriptionController)),
              ],
            ),
          ),
          Padding(
            padding:EdgeInsets.fromLTRB(0.0, 0.0, 10.0, MediaQuery.of(context).viewInsets.bottom),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(0.0),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Colors.black)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                  // minimumSize: MaterialStateProperty.all(Size(48.0, 32.0)),
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
          // RaisedButton(
          //   onPressed: updateProfileData,
          //   child: Text(
          //     'Update',
          //     style: TextStyle(
          //       color: Colors.blue,
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: RaisedButton(
          //     onPressed: cancelUpdate,
          //     child: Text(
          //       'Cancel',
          //       style: TextStyle(
          //         color: Colors.blue,
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
