import 'dart:io';
import 'package:image/image.dart' as Im;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../home.dart';

class ProjectPostAdd extends StatefulWidget {
  final String projectId;
  ProjectPostAdd({this.projectId});
  @override
  _ProjectPostAddState createState() => _ProjectPostAddState();
}

class _ProjectPostAddState extends State<ProjectPostAdd> {
  TextEditingController captionController = TextEditingController();
  bool isUploading = false;
  File file;
  String postId = Uuid().v4();
  final _formKey = GlobalKey<FormState>();

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
    );
    captionController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  createPostInFirestore({
    String mediaUrl,
    String location,
    String description,
  }) {
    projectPostsRef
        .document(widget.projectId)
        .collection('posts')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': currentUser.id,
      'username': currentUser.firstName,
      'mediaUrl': mediaUrl,
      'description': description,
      'timestamp': timestamp,
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child('post_$postId.jpg').putFile(imageFile);
    StorageTaskSnapshot storagesnap = await uploadTask.onComplete;
    String downloadUrl = await storagesnap.ref.getDownloadURL();
    return downloadUrl;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(imageFile, quality: 85),
      );
    setState(() {
      file = compressedImageFile;
    });
  }

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

  clearImage() {
    setState(() {
      file = null;
    });
    captionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100,
            width: double.infinity,
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: file == null
                      ? null
                      : DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(file),
                        ),
                ),
              ),
            ),
          ),
          TextField(
            key: _formKey,
            autocorrect: true,
            minLines: 1,
            maxLines: 5,
            cursorColor: Color.fromRGBO(89, 89, 89, 1),
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 20),
            controller: captionController,
            decoration: InputDecoration(
              hintText: 'Give Your Inputs',
              border: InputBorder.none,
            ),
          ),
          FlatButton.icon(
            color: Colors.blue,
            onPressed: handleChooseFromGallery,
            icon: Icon(Icons.photo_library),
            label: Text('Choose Image'),
          ),
          FlatButton(
            onPressed: captionController.text == null
                ? null
                : isUploading ? null : () => handleSubmit(),
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
