import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reachout/home.dart';
import 'package:reachout/models/education.dart';
import 'package:reachout/models/experience.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/screens/project_page.dart';
import 'package:reachout/screens/create_project_page.dart';
import 'package:reachout/screens/edit_education.dart';
import 'package:reachout/screens/edit_experience.dart';
import 'package:reachout/screens/edit_user_work.dart';
import 'package:reachout/screens/edit_profile.dart';
import 'package:reachout/widgets/education_row.dart';
import 'package:reachout/widgets/experience_row.dart';
import 'package:reachout/widgets/interests.dart';

class ProfilePage extends StatefulWidget {
  final String profileId;
  final VoidCallback onSignedOut;

  ProfilePage({
    this.profileId,
    this.onSignedOut,
  });
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String imageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3fZ_ebLrIR7-37WMGcyj_RO-0TTcZGtUKtg&usqp=CAU';
  bool isLoading;
  bool isCurrentUser;
  List<String> lists = ['Create New Project', 'Sign Out'];

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
            builder: (context) => EditProfile(
              profileId: currentUser.id,
            ),
          ),
        )
        .then((value) => setState(() {}));
  }

  editTimeline(String timeline) async {
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => timeline == 'Education'
                ? EditEducation(
                    profileId: currentUser.id,
                  )
                : EditExperience(
                    profileId: currentUser.id,
                  ),
          ),
        )
        .then((value) => setState(() {}));
  }

  editAreaOfWork() async {
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditUserWork(
              profileId: currentUser.id,
            ),
          ),
        )
        .then((value) => setState(() {}));
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
                  onPressed: text == 'Area of Work'
                      ? editAreaOfWork
                      : () {
                          modalSheetFunction(
                              EditProfile(profileId: currentUser.id));
                        } //editSection //modalSheetFunction(context)
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
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          currentUser.id == widget.profileId
              ? IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () => text == 'Experience'
                      ? modalSheetFunction(
                          EditExperience(profileId: currentUser.id))
                      : modalSheetFunction(
                          EditEducation(
                            profileId: currentUser.id,
                          ),
                        ) //editTimeline(text),
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
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: <Widget>[
          contactInfo('Email', profile.email),
        ],
      ),
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
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildAboutUser() {
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
                  profile.bio,
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
            child: Divider(
              thickness: 2,
            ),
          ),
          _buildTopHeader('Area of Work', Icons.desktop_windows),
          buildAreaOfWork(),
        ],
      ),
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

  Widget _buildTimeline() {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 35.0,
      child: Container(width: 1.0, color: Colors.black),
    );
  }

  buildEducation() {
    return Column(
      children: <Widget>[
        ...educations
            .map(
              (education) => EducationRow(education: education),
            )
            .toList(),
      ],
    );
  }

  buildExperience() {
    return Column(
      children: <Widget>[
        ...experiences
            .map(
              (experience) => ExperienceRow(experience: experience),
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
            radius: 40,
            backgroundImage: currentUser.photoUrl.trim() == ''
                ? NetworkImage(imageUrl)
                : NetworkImage(currentUser.photoUrl),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                profile.firstName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Aleppo-SY',
                        style: TextStyle(
                          color: Colors.black,
                          wordSpacing: 2,
                          letterSpacing: 4,
                        ),
                      ),
                    )
                  ],
                ),
              )
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
      return Text('');
    } else if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        function: handleUnfollowUser,
      );
    } else if (!isFollowing && !isRequested) {
      return buildButton(
        text: "Follow",
        function: handlefollowUser,
      );
    } else {
      return buildButton(
        text: "Cancel Request",
        function: cancelRequest,
      );
    }
  }

  cancelRequest() {
    print('object');
    requestsRef
        .document(widget.profileId)
        .collection('userRequests')
        .document(currentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    setState(() {
      isRequested = false;
    });
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .document(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    activityFeedRef
        .document(widget.profileId)
        .collection('feedItems')
        .document(currentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    getFollowers();
    getFollowing();
  }

  handlefollowUser() {
    setState(() {
      isRequested = true;
    });
    requestsRef
        .document(widget.profileId)
        .collection('userRequests')
        .document(currentUser.id)
        .setData({});
  }

  @override
  void initState() {
    isCurrentUser = widget.profileId == currentUser.id;
    if (!isCurrentUser) {
      setState(() {
        gotData = false;
      });
    }
    if (!gotData) {
      getUser();
      getProject();
    }
    getFollowers();
    getFollowing();
    checkIfRequested();
    checkIfFollowing();
    super.initState();
  }

  Future<void> getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.profileId).get();
    profile = User.fromDocument(doc);
    getInterests();
    getEducation();
    getExperience();
    setState(() {
      isLoading = false;
      if (isCurrentUser) {
        gotData = true;
      }
    });
  }

  Future<void> getProject() async {
    setState(() {
      isLoading = true;
    });
    lists = ['Create New Project', 'Sign Out'];
    project = {};
    QuerySnapshot doc = await projectRef
        .document(widget.profileId)
        .collection('userProject')
        .getDocuments();
    doc.documents.forEach((proj) {
      project[proj.data['name']] = proj.documentID;
      lists.add(proj.data['name']);
    });
    setState(() {
      isLoading = false;
    });
  }

  getFollowers() async {
    QuerySnapshot doc = await followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .getDocuments();
    setState(() {
      followerCount = doc.documents.length;
    });
  }

  getFollowing() async {
    QuerySnapshot doc = await followingRef
        .document(widget.profileId)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingCount = doc.documents.length;
    });
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUser.id)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  checkIfRequested() async {
    DocumentSnapshot doc = await requestsRef
        .document(widget.profileId)
        .collection('userRequests')
        .document(currentUser.id)
        .get();
    setState(() {
      isRequested = doc.exists;
    });
  }

  Future<void> getInterests() async {
    setState(() {
      isLoading = true;
    });
    interests = [];
    profile.areaOfWork.forEach((element) {
      interests.add(element.toString());
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getExperience() async {
    setState(() {
      isLoading = true;
    });
    experiences = [];
    profile.experiences.forEach((element) {
      Experience exp = Experience(
        date: element['date'],
        description: element['description'],
        company: element['company'],
        jobTitle: element['jobTitle'],
        active: element['active'],
      );
      experiences.add(exp);
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getEducation() async {
    setState(() {
      isLoading = true;
    });
    educations = [];
    profile.educations.forEach((element) {
      Education edu = Education(
        date: element['date'],
        description: element['description'],
        institute: element['institute'],
        title: element['title'],
        active: element['active'],
      );
      educations.add(edu);
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> refresh() async {
    getProject();
    getUser();
  }

  AppBar appBar() {
    return AppBar(
      actions: widget.profileId != currentUser.id
          ? null
          : <Widget>[
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return lists.map((choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                onSelected: choiceAction,
              ),
            ],
    );
  }

  void choiceAction(String choice) {
    if (choice == 'Create New Project') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateProjectPage(
            profileId: widget.profileId,
          ),
        ),
      );
    } else if (choice == 'Sign Out') {
      widget.onSignedOut();
    } else {
      String id = project[choice];
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProjectPage(
            profileId: widget.profileId,
            projectId: id,
          ),
        ),
      );
    }
  }

  buildProjects() {
    Iterable<String> projectNames = project.keys;
    return Column(
      children: <Widget>[
        ...projectNames.map(
          (name) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(name),
              ),
            );
          },
        ).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
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
                            _buildTopHeader('About', Icons.person_outline),
                            buildAboutUser(),
                            buildDivider(),
                            _buildTimelineHeader(
                                'Experience', MdiIcons.briefcaseOutline),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Stack(
                                children: <Widget>[
                                  _buildTimeline(),
                                  buildExperience(),
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
                                'Education', MdiIcons.schoolOutline),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Stack(
                                children: <Widget>[
                                  _buildTimeline(),
                                  buildEducation(),
                                ],
                              ),
                            ),
                            buildDivider(),
                            _buildTopHeader('Projects', Icons.group_work),
                            buildProjects(),
                            buildDivider(),
                            _buildTopHeader('Contact', Icons.phone),
                            buildContactInfo(),
                            SizedBox(
                              height: 25,
                              width: double.infinity,
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
                ],
              ),
              onRefresh: refresh,
            ),
    );
  }
}
