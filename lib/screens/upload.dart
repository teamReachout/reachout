import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image/image.dart' as Im;
import 'package:reachout/widgets/loading_indicator.dart';
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
                              maxLines: 5,
                              cursorColor: Color.fromRGBO(89, 89, 89, 1),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontSize: 20),
                              controller: captionController,
                              decoration: InputDecoration(
                                hintText: 'Idea for the day...',
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
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Tags(
                        key: _tagKey,
                        itemCount: tags.length,
                        columns: 3,
                        textField: TagsTextField(
                          hintText: 'Enter 1 word tags',
                          textStyle: TextStyle(
                            fontSize: 14,
                          ),
                          inputDecoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
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
                            alignment: MainAxisAlignment.spaceAround,
                            title: currentItem.title,
                            customData: currentItem.customData,
                            textStyle: TextStyle(fontSize: 14),
                            combine: ItemTagsCombine.onlyText,
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

// Expanded(
//   flex: 2,
//   child: Padding(
//     padding: EdgeInsets.only(left: 5.0),
//     child: Container(
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.blueAccent)),
//       child: ListTile(
//         leading: Icon(
//           Icons.pin_drop,
//           color: Theme.of(context).primaryColor,
//           size: 35,
//         ),
//         title: Container(
//           width: 250,
//           child: TextField(
//             controller: locationController,
//             decoration: InputDecoration(
//               hintText: 'Location',
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//         trailing: CircleAvatar(
//           backgroundColor:
//               Color.fromRGBO(244, 248, 245, 1),
//           radius: 25,
//           child: IconButton(
//             onPressed: getUserLocation,
//             icon: Icon(
//               Icons.my_location,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
