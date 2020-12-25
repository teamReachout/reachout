import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reachout/home.dart';
import 'package:reachout/widgets/loading_indicator.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class AddProblems extends StatefulWidget {
  @override
  _AddProblemsState createState() => _AddProblemsState();
}

class _AddProblemsState extends State<AddProblems> {
  TextEditingController captionController = TextEditingController();
  TextEditingController headingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isUploading = false;
  String problemId = Uuid().v4();
  File file;

  handleChooseFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
    );
    final pickedImageFile = File(pickedImage.path);

    setState(() {
      file = pickedImageFile;
    });
  }

  handleSubmit() async {
    String mediaUrl;
    setState(() {
      isUploading = true;
    });
    if (file != null) {
      await compressImage();
      mediaUrl = await uploadImage(file);
    }
    createPostInFirestore(
      mediaUrl: mediaUrl == null ? '' : mediaUrl,
      description: captionController.text,
      heading: headingController.text,
    );
    captionController.clear();
    headingController.clear();
    setState(() {
      file = null;
      isUploading = false;
      problemId = Uuid().v4();
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child('problem_$problemId.jpg').putFile(imageFile);
    StorageTaskSnapshot storagesnap = await uploadTask.onComplete;
    String downloadUrl = await storagesnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore({
    String mediaUrl,
    String description,
    String heading,
  }) {
    problemsRef.document(problemId).setData({
      'problemId': problemId,
      'ownerId': currentUser.id,
      'username': currentUser.firstName,
      'mediaUrl': mediaUrl,
      'description': description,
      'heading': heading,
      'upvotes': {},
      'downvotes': {}
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$problemId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(imageFile, quality: 85),
      );
    setState(() {
      file = compressedImageFile;
    });
  }

  buildUploadForm() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: SafeArea(
          child: AppBar(
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(7),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: captionController.text == null
                    ? null
                    : isUploading
                        ? null
                        : () => handleSubmit(),
                child: Text(
                  'POST',
                  style: TextStyle(
                    color: Color.fromRGBO(244, 248, 245, 1),
                    fontWeight: FontWeight.normal,
                    letterSpacing: 2.0,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
            primary: true,
          ),
        ),
        preferredSize: Size.fromHeight(55),
      ),
      body: isUploading
          ? LoadingIndicator()
          : Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 0.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              key: _formKey,
                              autocorrect: true,
                              minLines: 1,
                              maxLines: 1,
                              cursorColor: Color.fromRGBO(89, 89, 89, 1),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontSize: 20),
                              controller: headingController,
                              decoration: InputDecoration(
                                hintText: 'Heading',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.photo_library),
                            onPressed: handleChooseFromGallery,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  TextField(
                    // key: _formKey,
                    autocorrect: true,
                    minLines: 1,
                    maxLines: 5,
                    cursorColor: Color.fromRGBO(89, 89, 89, 1),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 20),
                    controller: captionController,
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  file == null
                      ? Expanded(
                          child: Container(),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 32,
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: kElevationToShadow[3],
                              ),
                              child: file == null
                                  ? null
                                  : Image(
                                      image: FileImage(file),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
  }
}
