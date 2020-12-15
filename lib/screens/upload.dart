import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image/image.dart' as Im;
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../home.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  bool isUploading = false;
  File file;
  String postId = Uuid().v4();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<TagsState> _tagKey = GlobalKey<TagsState>();
  List tags = new List();

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
    locationController.clear();
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String formattedAddress =
        '${placemark.subThoroughfare}, ${placemark.subLocality}, ${placemark.locality}';
    locationController.text = formattedAddress;
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
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
      tags.clear();
    });
  }

  createPostInFirestore({
    String mediaUrl,
    String location,
    String description,
  }) {
    postsRef
        .document(currentUser.id)
        .collection('userPosts')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': currentUser.id,
      'username': currentUser.firstName,
      'mediaUrl': mediaUrl,
      'description': description,
      'location': location,
      'timestamp': timestamp,
      'likes': {}
    });

    tags.forEach((element) {
      String tag = element.title.toString();
      tagsRef
          .document(tag)
          .collection(currentUser.id)
          .document(postId)
          .setData({
        'postId': postId,
        'ownerId': currentUser.id,
        'username': currentUser.firstName,
        'mediaUrl': mediaUrl,
        'description': description,
        'location': location,
        'timestamp': timestamp,
        'likes': {}
      });
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

  Scaffold buildUploadForm() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 248, 245, 1),
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
                    : isUploading ? null : () => handleSubmit(),
                child: Text(
                  'Post',
                  style: TextStyle(
                    color: Color.fromRGBO(244, 248, 245, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: Color.fromRGBO(244, 248, 245, 1),
              ),
              onPressed: clearImage,
            ),
            primary: true,
            title: Text(
              'Share a post',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(244, 248, 245, 1),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(44),
      ),
      body: isUploading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      currentUser.photoUrl,
                    ),
                  ),
                  title: Container(
                    width: 250,
                    child: Text(
                        currentUser.firstName + " " + currentUser.lastName),
                  ),
                ),
                Divider(
                  color: Color.fromRGBO(89, 89, 89, 1),
                  thickness: 2,
                  indent: 45,
                  endIndent: 45,
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
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
                      ),
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: handleChooseFromGallery,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).primaryColor,
                    size: 35,
                  ),
                  title: Container(
                    width: 250,
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Location',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Color.fromRGBO(244, 248, 245, 1),
                    radius: 25,
                    child: IconButton(
                      onPressed: getUserLocation,
                      icon: Icon(
                        Icons.my_location,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Tags(
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
                ),
                Expanded(
                  child: Container(
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
  }
}
