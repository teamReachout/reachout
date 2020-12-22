import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/models/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  final String profileId;

  EditProfile({this.profileId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading;
  User user;

  buildField(String heading, TextField textFieldFunction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(7, 12, 0, 0),
          child: Text(
            heading.toUpperCase(),
            style: kTextHeaderTextFields,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 7.0),
          child: textFieldFunction, //multilineTextField(boxText, controller),
        )
      ],
    );
  }

  cancelUpdate() {
    Navigator.of(context).pop();
  }

  updateProfileData() {
    usersRef.document(widget.profileId).updateData({
      "bio": bioController.text,
    });
    if (emailController.text != '') {
      usersRef.document(widget.profileId).updateData({
        "email": emailController.text,
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
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
                      "Bio", multilineTextField('Bio', bioController)),
                  buildField("Email",
                      singlelineTextField('Email', emailController)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 6.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(0.0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                      side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
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
                )
                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //     style: ButtonStyle(
                //       backgroundColor:
                //           MaterialStateProperty.all(Colors.white),
                //       elevation: MaterialStateProperty.all(2.0),
                //     ),
                //     onPressed: cancelUpdate,
                //     child: Text(
                //       'CANCEL',
                //       style: GoogleFonts.roboto(
                //         color: Colors.blue,
                //         fontSize: 20,
                //         fontWeight: FontWeight.normal,
                //         letterSpacing: 0.4,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
