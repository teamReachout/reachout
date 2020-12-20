import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/project.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/screens/edit_project.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:reachout/screens/edit_project_work.dart';
import 'package:reachout/screens/edit_project_members.dart';
import 'package:reachout/screens/edit_projects_posts.dart';
import 'package:reachout/widgets/interests.dart';
import 'package:reachout/widgets/user_card.dart';

class ProjectPage extends StatefulWidget {
  final String projectId;
  final String profileId;

  ProjectPage({
    this.projectId,
    this.profileId,
  });
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool isLoading;
  List<String> interests = [];
  bool isFollowing = false;
  int _focusedIndex = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<User> cofounders = [];
  List<User> collaborators = [];
  List<String> posts = [];
  Project proj;
  int _widgetIndex = 0;

  createColumn(int numb, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          numb.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
          ),
        )
      ],
    );
  }

  buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Divider(
        color: Color.fromRGBO(217, 217, 217, 1),
        thickness: 10,
      ),
    );
  }

  editSection() async {
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditProject(
              projectId: widget.projectId,
            ),
          ),
        )
        .then(
          (value) => setState(() {}),
        );
  }

  editTimeline(String timeline) async {
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditProjectMembers(
              profileId: currentUser.id,
              projectId: widget.projectId,
              users: timeline == 'Collaborators' ? collaborators : cofounders,
              designation: timeline,
            ),
          ),
        )
        .then((value) => setState(() {}));
  }

  editPosts() async {
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditProjectsPosts(
              projectId: widget.projectId,
              posts: posts,
            ),
          ),
        )
        .then((value) => setState(() {}));
  }

  editAreaOfWork() async {
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditProjectWork(
              profileId: widget.profileId,
              projectId: widget.projectId,
            ),
          ),
        )
        .then((value) => setState(() {}));
  }

  Widget _buildTopHeader(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          currentUser.id == widget.profileId
              ? IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed:
                      text == 'Area of Work' ? editAreaOfWork : editSection,
                )
              : Icon(icon, color: Colors.black),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
          ),
        ],
      ),
    );
  }

  Widget _buildPostHeader(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          currentUser.id == widget.profileId
              ? IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: editPosts,
                )
              : Icon(icon, color: Colors.black),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineHeader(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          currentUser.id == widget.profileId
              ? IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () => editTimeline(text),
                )
              : Icon(icon, color: Colors.black),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
          ),
        ],
      ),
    );
  }

  buildContactInfo() {
    return FutureBuilder(
      future: projectRef
          .document(widget.profileId)
          .collection('userProject')
          .document(widget.projectId)
          .get(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        Project project = Project.fromDocument(snapshot.data);
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: <Widget>[
              contactInfo('Email', project.contact),
            ],
          ),
        );
      },
    );
  }

  Widget contactInfo(String title, String email) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            radius: 2.5,
            backgroundColor: Colors.grey,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 18.0),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.0),
                child: Text(
                  email,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildAboutProject() {
    return FutureBuilder(
      future: projectRef
          .document(widget.profileId)
          .collection('userProject')
          .document(widget.projectId)
          .get(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        Project project = Project.fromDocument(snapshot.data);
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  Expanded(
                    child: Text(
                      project.bio,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildWhyProject() {
    return FutureBuilder(
      future: projectRef
          .document(widget.profileId)
          .collection('userProject')
          .document(widget.projectId)
          .get(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        Project project = Project.fromDocument(snapshot.data);
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  Expanded(
                    child: Text(
                      project.why,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildAreaOfWork() {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        ...interests
            .map(
              (interest) => Interests(
                interest: interest,
              ),
            )
            .toList(),
      ],
    );
  }

  buildCollaborator() {
    return Column(
      children: <Widget>[
        ...collaborators
            .map(
              (collaborator) => UserCard(user: collaborator),
            )
            .toList(),
      ],
    );
  }

  buildFounders() {
    return Column(
      children: <Widget>[
        ...cofounders
            .map(
              (founder) => UserCard(user: founder),
            )
            .toList(),
      ],
    );
  }

  buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 28.0, top: 7),
          child: CircleAvatar(
            radius: 64,
            backgroundImage: NetworkImage(proj.photoUrl),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                proj.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildProfileData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        createColumn(
          followerCount,
          'Followers',
        ),
        Container(
          color: Colors.black,
          width: 0.2,
          height: 22,
        ),
        createColumn(
          followingCount,
          'Following',
        ),
        Container(
          color: Colors.black,
          width: 0.2,
          height: 22,
        ),
        buildProfileButton(),
      ],
    );
  }

  buildButton({
    String text,
    Function function,
  }) {
    return FlatButton(
      onPressed: function,
      child: Container(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          color: Colors.transparent,
          border: Border.all(
            color: Colors.blue,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    var isProfileOwner = currentUser.id == widget.profileId;
    if (isProfileOwner) {
      return buildButton(
        text: "Edit",
        function: null,
      );
    } else if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        // function: handleUnfollowUser,
        function: null,
      );
    } else if (!isFollowing) {
      return buildButton(
        text: "Follow",
        // function: handlefollowUser,
        function: null,
      );
    }
  }

  // handleUnfollowUser() {
  //   setState(() {
  //     isFollowing = false;
  //   });
  //   followersRef
  //       .document(widget.profileId)
  //       .collection('userFollowers')
  //       .document(currentUser.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  //   followingRef
  //       .document(currentUser.id)
  //       .collection('userFollowing')
  //       .document(widget.profileId)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  //   activityFeedRef
  //       .document(widget.profileId)
  //       .collection('feedItems')
  //       .document(currentUser.id)
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  //   getFollowers();
  //   getFollowing();
  // }

  // handlefollowUser() {
  //   setState(() {
  //     isFollowing = true;
  //   });
  //   followersRef
  //       .document(widget.profileId)
  //       .collection('userFollowers')
  //       .document(currentUser.id)
  //       .setData({});
  //   followingRef
  //       .document(currentUser.id)
  //       .collection('userFollowing')
  //       .document(widget.profileId)
  //       .setData({});
  //   activityFeedRef
  //       .document(widget.profileId)
  //       .collection('feedItems')
  //       .document(currentUser.id)
  //       .setData({
  //     'type': 'follow',
  //     'ownerId': widget.profileId,
  //     'userId': currentUser.id,
  //     'username': currentUser.firstName,
  //     'userProfileImg': currentUser.photoUrl,
  //     'timestamp': timestamp,
  //   });
  //   getFollowers();
  //   getFollowing();
  // }

  @override
  void initState() {
    // getFollowers();
    // getFollowing();
    getInterests();
    getCofounders();
    getCollaborators();
    getPosts();
    // checkIfFollowing();
    getProject();
    super.initState();
  }

  getPosts() async {
    QuerySnapshot doc = await projectPostsRef
        .document(widget.projectId)
        .collection('posts')
        .getDocuments();
    doc.documents.forEach((doc) {
      posts.add(doc.data['mediaUrl']);
    });
  }

  getProject() async {
    DocumentSnapshot doc = await projectRef
        .document(widget.profileId)
        .collection('userProject')
        .document(widget.projectId)
        .get();
    proj = Project.fromDocument(doc);
  }

  getCollaborators() async {
    setState(() {
      isLoading = true;
    });
    collaborators = [];
    DocumentSnapshot doc = await projectRef
        .document(widget.profileId)
        .collection('userProject')
        .document(widget.projectId)
        .get();
    List<dynamic> users = doc.data['collaborators'];
    users.forEach((userId) async {
      DocumentSnapshot document =
          await usersRef.document(userId.toString()).get();
      User user = User.fromDocument(document);
      collaborators.add(user);
    });
    setState(() {
      isLoading = false;
    });
  }

  getCofounders() async {
    setState(() {
      isLoading = true;
    });
    cofounders = [];
    DocumentSnapshot doc = await projectRef
        .document(widget.profileId)
        .collection('userProject')
        .document(widget.projectId)
        .get();
    List<dynamic> users = doc.data['founders'];
    users.forEach((userId) async {
      DocumentSnapshot document =
          await usersRef.document(userId.toString()).get();
      User user = User.fromDocument(document);
      cofounders.add(user);
    });
    setState(() {
      isLoading = false;
    });
  }

  // getFollowers() async {
  //   QuerySnapshot doc = await followersRef
  //       .document(widget.profileId)
  //       .collection('userFollowers')
  //       .getDocuments();
  //   setState(() {
  //     followerCount = doc.documents.length;
  //   });
  // }

  // getFollowing() async {
  //   QuerySnapshot doc = await followingRef
  //       .document(widget.profileId)
  //       .collection('userFollowing')
  //       .getDocuments();
  //   print(doc.documents.length);
  //   setState(() {
  //     followingCount = doc.documents.length;
  //   });
  // }

  // checkIfFollowing() async {
  //   DocumentSnapshot doc = await followersRef
  //       .document(widget.profileId)
  //       .collection('userFollowers')
  //       .document(currentUser.id)
  //       .get();
  //   setState(() {
  //     isFollowing = doc.exists;
  //   });
  // }

  Future<void> getInterests() async {
    setState(() {
      isLoading = true;
    });
    interests = [];
    DocumentSnapshot doc = await projectRef
        .document(widget.profileId)
        .collection('userProject')
        .document(widget.projectId)
        .get();

    Project project = Project.fromDocument(doc);
    project.areaOfWork.forEach((element) {
      interests.add(element.toString());
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> refresh() async {
    getCofounders();
    getCollaborators();
    getInterests();
  }

  AppBar appBar() {
    return AppBar();
  }

  Widget _buildPostItem(BuildContext ctx, int i) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 400,
        width: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(posts[i]),
          ),
        ),
      ),
    );
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: isLoading == true
          ? CircularProgressIndicator()
          : RefreshIndicator(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildProfileHeader(),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 38,
                          left: 38,
                          top: 15,
                          bottom: 12,
                        ),
                        child: buildProfileData(),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            top: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffefefef),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(34),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DraggableScrollableSheet(
                    builder: (ctx, controller) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xffefefef),
                        ),
                        child: ListView(
                          controller: controller,
                          children: <Widget>[
                            _buildTopHeader(
                                'Area of Work', Icons.desktop_windows),
                            buildAreaOfWork(),
                            Divider(
                              thickness: 2,
                            ),
                            _buildTopHeader('About', Icons.person_outline),
                            buildAboutProject(),
                            buildDivider(),
                            _buildTopHeader(
                                'Why we Started', Icons.person_outline),
                            buildWhyProject(),
                            Divider(
                              thickness: 2,
                            ),
                            _buildPostHeader('Posts', Icons.photo_album),
                            Container(
                              height: 500,
                              width: 500,
                              child: ScrollSnapList(
                                onItemFocus: _onItemFocus,
                                itemSize: 0,
                                itemBuilder: _buildPostItem,
                                itemCount: posts.length,
                                reverse: true,
                              ),
                            ),
                            buildDivider(),
                            _buildTimelineHeader(
                              'Founders',
                              MdiIcons.briefcaseOutline,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Stack(
                                children: <Widget>[
                                  buildFounders(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                            _buildTimelineHeader(
                              'Collaborators',
                              MdiIcons.schoolOutline,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Stack(
                                children: <Widget>[
                                  buildCollaborator(),
                                ],
                              ),
                            ),
                            buildDivider(),
                            _buildTopHeader('Contact', Icons.phone),
                            buildContactInfo(),
                          ],
                        ),
                      );
                    },
                    initialChildSize: 0.725,
                    minChildSize: 0.725,
                    expand: true,
                    maxChildSize: 1,
                  ),
                ],
              ),
              onRefresh: refresh,
            ),
    );
  }
}
