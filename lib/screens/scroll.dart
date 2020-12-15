import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/widgets/interests.dart';

import '../home.dart';

class Scroll extends StatefulWidget {
  final String profileId;

  Scroll({this.profileId});

  @override
  _ScrollState createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  List<String> interests = [
    'Software',
    'Business Development',
    'Automation',
    'Entrepreneurship',
  ];
  buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Divider(
        color: Color.fromRGBO(217, 217, 217, 1),
        thickness: 10,
      ),
    );
  }

  Widget _buildTopHeader(String text) {
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
          Icon(
            text == 'Experience'
                ? MdiIcons.briefcaseOutline
                : text == 'Education'
                    ? MdiIcons.schoolOutline
                    : text == 'Contact'
                        ? Icons.phone
                        : text == 'Awards'
                            ? MdiIcons.trophyOutline
                            : Icons.person_outline,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
          ),
        ],
      ),
    );
  }

  buildContactInfo() {
    return FutureBuilder(
      future: usersRef.document(widget.profileId).get(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: <Widget>[
              contactInfo('Email', user.email),
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

  buildAboutUser() {
    return FutureBuilder(
      future: usersRef.document(widget.profileId).get(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                    ),
                    Expanded(
                      child: Text(
                        user.bio,
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
                buildAreaOfInterest(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAreaOfInterest() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: double.infinity,
          ),
          DraggableScrollableSheet(
            builder: (ctx, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  controller: controller,
                  children: <Widget>[
                    // buildProfileHeader(),
                    // buildDivider(),
                    _buildTopHeader('About'),
                    buildAboutUser(),
                    buildDivider(),
                    // _buildPostHeader('Posts'),
                    // buildProfilePosts(),
                    // buildDivider(),
                    _buildTopHeader('Experience'),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 20.0),
                    //   child: Stack(
                    //     children: <Widget>[
                    //       _buildTimeline(),
                    //       Column(
                    //         children: <Widget>[
                    //           ...experiences
                    //               .map(
                    //                 (experience) =>
                    //                     ExperienceRow(experience: experience),
                    //               )
                    //               .toList(),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    _buildTopHeader('Education'),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 20.0),
                    //   child: Stack(
                    //     children: <Widget>[
                    //       _buildTimeline(),
                    //       Column(
                    //         children: <Widget>[
                    //           ...educations
                    //               .map(
                    //                 (education) =>
                    //                     EducationRow(education: education),
                    //               )
                    //               .toList(),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    buildDivider(),
                    _buildTopHeader('Contact'),
                    buildContactInfo(),
                  ],
                ),
              );
            },
            initialChildSize: 0.6,
            minChildSize: 0.6,
            expand: true,
            maxChildSize: 1,
          ),
        ],
      ),
    );
  }
}
