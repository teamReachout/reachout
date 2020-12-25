import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/project.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProjectWork extends StatefulWidget {
  final String projectId;
  final String profileId;

  EditProjectWork({
    this.projectId,
    this.profileId,
  });
  @override
  _EditProjectWorkState createState() => _EditProjectWorkState();
}

class _EditProjectWorkState extends State<EditProjectWork> {
  final GlobalKey<TagsState> _tagKey = GlobalKey<TagsState>();
  bool isLoading;
  List<String> interests = [];
  List tags = new List();
  Project project;

  cancelUpdate() {
    Navigator.of(context).pop();
  }

  updateProfileData() async {
    addToInterests();
    DocumentSnapshot doc = await projectRef
        .document(widget.profileId)
        .collection('userProject')
        .document(widget.projectId)
        .get();
    project = Project.fromDocument(doc);
    projectRef
        .document(widget.profileId)
        .collection('userProject')
        .document(widget.projectId)
        .updateData({
      'areaOfWork': interests,
    });
    Navigator.of(context).pop();
  }

  addToInterests() {
    tags.forEach((element) {
      String tag = element.title.toString();
      interests.add(tag);
    });
  }

  @override
  void initState() {
    getInterests();
    super.initState();
  }

  getInterests() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await projectRef
        .document(widget.profileId)
        .collection('userProject')
        .document(widget.projectId)
        .get();
    Project project = Project.fromDocument(doc);
    project.areaOfWork.forEach((element) {
      tags.add(
        Item(
          title: element.toString(),
        ),
      );
    });
    setState(() {
      isLoading = false;
    });
  }

  buildTags() {
    return Tags(
      key: _tagKey,
      itemCount: tags.length,
      columns: 3,
      // textField: singlelineTextField('Enter 1 Word Tag', null),
      textField: TagsTextField(
        hintText: 'Enter 1 word tags',
        inputDecoration: InputDecoration(
            focusColor: Colors.red,
            //hintText: text,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        textStyle: TextStyle(
          fontSize: 14,
        ),
        onSubmitted: (tag) {
          if (tag.split(' ').length == 1) {
            setState(() {
              tags.add(
                Item(
                  title: tag,
                ),
              );
            });
          }
        },
      ),
      itemBuilder: (i) {
        final Item currentItem = tags[i];
        return ItemTags(
          index: i,
          title: currentItem.title,
          customData: currentItem.customData,
          textStyle: TextStyle(fontSize: 14),
          combine: ItemTagsCombine.withTextBefore,
          onPressed: null,
          onLongPressed: null,
          removeButton: ItemTagsRemoveButton(
            onRemoved: () {
              setState(() {
                tags.removeAt(i);
              });
              return true;
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Column(
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildTags(),
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
            ],
          );
  }
}
