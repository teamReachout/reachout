import 'package:flutter/material.dart';
import 'package:reachout/models/users.dart';
import 'package:reachout/widgets/update_project_members.dart';

class EditProjectMembers extends StatefulWidget {
  List<User> users;
  String profileId;
  String projectId;
  String designation;
  EditProjectMembers({
    this.projectId,
    this.profileId,
    this.users,
    this.designation,
  });
  @override
  _EditProjectMembersState createState() => _EditProjectMembersState();
}

class _EditProjectMembersState extends State<EditProjectMembers> {
  List<String> usersId = [];

  @override
  void initState() {
    super.initState();
    getIds();
  }

  getIds() async {
    widget.users.forEach((user) {
      usersId.add(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.search,
            color: const Color.fromRGBO(244, 248, 245, 1),
          ),
          onPressed: () => showSearch(
            context: context,
            delegate: UpdateProjectMembers(
              members: usersId,
              projectId: widget.projectId,
              profileId: widget.profileId,
              designation: widget.designation,
            ),
          ),
        ),
      ),
    );
  }
}
