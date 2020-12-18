import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/project.dart';

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
      textField: TagsTextField(
        hintText: 'Enter 1 word tags',
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
    return Scaffold(
      body: isLoading
          ? CircularProgressIndicator()
          : ListView(
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
                            buildTags(),
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
