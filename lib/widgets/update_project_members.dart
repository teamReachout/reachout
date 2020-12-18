import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/users.dart';

class UpdateProjectMembers extends SearchDelegate<dynamic> {
  List<String> members;
  String profileId;
  String projectId;
  String designation;
  UpdateProjectMembers({
    this.members,
    this.profileId,
    this.projectId,
    this.designation,
  });
  List<User> data = [];
  QuerySnapshot dataSnapshot;
  final recent = ['ff', 'dd'];
  getData() async {
    dataSnapshot = await usersRef.getDocuments();

    data = dataSnapshot.documents.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('data');
  }

  goToResults(BuildContext context, String id) {
    String key = designation == 'Collaborators' ? 'collaborators' : 'founders';
    members.add(id);
    projectRef
        .document(profileId)
        .collection('userProject')
        .document(projectId)
        .updateData({
      key: members,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    getData();
    final suggestionList =
        data.where((e) => e.firstName.startsWith(query)).toList();
    // data
    //     .where((e) => e.firstName.startsWith(query.toUpperCase()))
    //     .toList()
    //     .forEach((e) {
    //   suggestionList.add(e);
    // });
    if (suggestionList.isEmpty) {
      return Text('Search...');
    } else {
      return ListView.builder(
        itemBuilder: (ctx, i) => ListTile(
          onTap: () => goToResults(context, suggestionList[i].id),
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(suggestionList[i].photoUrl),
          ),
          title: RichText(
            text: TextSpan(
              text: suggestionList[i].firstName.substring(0, query.length),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: suggestionList[i].firstName.substring(query.length),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        itemCount: suggestionList.length,
      );
    }
  }
}
