import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:flutter/services.dart';

// class Scroller extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               physics: BouncingScrollPhysics(),
//                               child: Row(
//                                 children: [
//                                   Card(
//                                     // color: Colors.grey[200],
//                                     child: Column(
//                                       children: [
//                                         _buildTimelineHeader(
//                                           'Founders',
//                                           MdiIcons.briefcaseOutline,
//                                         ),
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 8.0),
//                                           child: Stack(
//                                             children: <Widget>[
//                                               buildFounders(),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Card(
//                                     color: Colors.grey[200],
//                                     child: Column(
//                                       children: [
//                                         _buildTimelineHeader(
//                                           'Collaborators',
//                                           MdiIcons.schoolOutline,
//                                         ),
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 20.0),
//                                           child: Stack(
//                                             children: <Widget>[
//                                               buildCollaborator(),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(bottom: 8.0),
//                                     child: Card(
//                                       color: Colors.grey[200],
//                                       child: Column(
//                                         children: [
//                                           _buildTopHeader(
//                                               'Contact', Icons.phone),
//                                           buildContactInfo(),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );

//   }
// }

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

  createColumn(int numb, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          numb.toString(),
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.white70,
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
              padding: const EdgeInsets.only(left: 14.0),
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
                  onPressed: text == 'Area of Work'
                      ? //editAreaOfWork
                      () {
                          modalSheetFunction(
                            EditProjectWork(
                              profileId: currentUser.id,
                              projectId: widget.projectId,
                            ),
                          );
                        }
                      : () {
                          modalSheetFunction(
                            EditProject(
                              projectId: widget.projectId,
                            ),
                          );
                        } //editAreaOfWork : editSection,
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
          padding: const EdgeInsets.fromLTRB(0, 6, 0, 12),
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
                padding: EdgeInsets.only(top: 3.0),
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
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 14),
                  ),
                  Expanded(
                    child: Text(project.bio,
                        style: GoogleFonts.quicksand(
                            fontSize: 15, fontWeight: FontWeight.w500)),
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
                    padding: EdgeInsets.only(left: 14),
                  ),
                  Expanded(
                    child: Text(project.why,
                        // 'HELOO',
                        style: GoogleFonts.quicksand(
                            fontSize: 15, fontWeight: FontWeight.w500)),
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
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 28.0, top: 7),
            child: CircleAvatar(
              radius: 48,
              backgroundImage:
                  proj.photoUrl == null ? null : NetworkImage(proj.photoUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 34.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  proj.name.toUpperCase(),
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 36,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          color: Colors.white12,
          width: 0.2,
          height: 22,
        ),
        createColumn(
          followingCount,
          'Following',
        ),
        Container(
          color: Colors.white12,
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
            Radius.circular(16),
          ),
          color: Colors.transparent,
          border: Border.all(
            color: Colors.white70,
          ),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white70,
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
    print(posts);
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

  modalSheetFunction(Widget editWidget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return editWidget; //EditProfile(profileId: currentUser.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent //Color(0xFFff9d72),
          ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: appBar(),
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFa7c5eb)
      // ),
      body: isLoading == true
          ? CircularProgressIndicator()
          : RefreshIndicator(
              child: Stack(
                overflow: Overflow.clip,
                alignment: Alignment.center,
                // fit: StackFit.expand,
                // alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  DraggableScrollableSheet(
                    builder: (ctx, controller) {
                      return Container(
                        // decoration: BoxDecoration(
                        //    borderRadius: BorderRadius.circular(30.0),
                        //   color: Color(0xffefefef),
                        // color: Colors.white,
                        // ),
                        child: ListView(
                          controller: controller,
                          children: <Widget>[
                            // Container(
                            //   width: double.infinity,
                            //   height: 50,
                            //   color: Colors.red
                            // ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0.0),
                              child: Card(
                                elevation: 0.5,
                                color: Colors.grey[200],
                                child: Column(
                                  children: [
                                    _buildTopHeader(
                                        'Area of Work', Icons.desktop_windows),
                                    Divider(
                                      thickness: 1,
                                      endIndent:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      indent: 5,
                                      color: Colors.black12,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: buildAreaOfWork()),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0.5,
                              color: Colors.grey[200],
                              child: Column(
                                children: [
                                  _buildTopHeader(
                                      'About', Icons.person_outline),
                                  Divider(
                                    thickness: 1,
                                    endIndent:
                                        MediaQuery.of(context).size.width * 0.5,
                                    indent: 5,
                                    color: Colors.black12,
                                  ),
                                  buildAboutProject(),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 0.5,
                              color: Colors.grey[200],
                              child: Column(
                                children: [
                                  _buildTopHeader(
                                      'Our Story', Icons.person_outline),
                                  Divider(
                                    thickness: 1,
                                    endIndent:
                                        MediaQuery.of(context).size.width * 0.5,
                                    indent: 5,
                                    color: Colors.black12,
                                  ),
                                  buildWhyProject(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Card(
                                elevation: 0.5,
                                color: Colors.grey[200],
                                child: Column(
                                  children: [
                                    _buildPostHeader(
                                        'Posts', Icons.photo_album),
                                    Container(
                                      color: Colors.grey[100],
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: MediaQuery.of(context).size.width,
                                      child: ScrollSnapList(
                                        onItemFocus: _onItemFocus,
                                        itemSize: 100,
                                        itemBuilder: _buildPostItem,
                                        itemCount: posts.length,
                                        focusOnItemTap: true,
                                        reverse: true,
                                        onReachEnd: null,
                                        // dynamicItemSize: true,
                                      ),
                                      // child: CarouselSlider(

                                      //   options: CarouselOptions(
                                      //     scrollDirection: Axis.horizontal,
                                      //     aspectRatio: 16 / 9,
                                      //   ),
                                      //   items: [
                                      //     ...posts.map((post) {
                                      //       Container(
                                      //         child: Center(
                                      //           child: Image.network(
                                      //             post,
                                      //             fit: BoxFit.cover,
                                      //             width: 1000,
                                      //           ),
                                      //         ),
                                      //       );
                                      //     }).toList(),
                                      //   ],
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    initialChildSize: 0.725,
                    minChildSize: 0.725,
                    expand: true,
                    maxChildSize: 1,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF393e46),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            buildProfileHeader(),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 38,
                                left: 38,
                                top: 15,
                                bottom: 18,
                              ),
                              child: buildProfileData(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      height: 60,
                      width: 60,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: FloatingActionButton(
                          onPressed: () {
                            modalSheetFunction(
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 18, 0, 10),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text('TEAM INFORMATION',
                                          style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            letterSpacing: 0.8,
                                            fontWeight: FontWeight.w300,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1.5,
                                              color: Colors.black26)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildTimelineHeader(
                                            'Founders',
                                            MdiIcons.briefcaseOutline,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Stack(
                                              children: <Widget>[
                                                buildFounders(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1, color: Colors.black26)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildTimelineHeader(
                                            'Collaborators',
                                            MdiIcons.schoolOutline,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Stack(
                                              children: <Widget>[
                                                buildCollaborator(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1, color: Colors.black26)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildTopHeader(
                                              'Contact', Icons.phone),
                                          buildContactInfo(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Icon(Icons.group, size: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onRefresh: refresh,
            ),
    );
  }
}
