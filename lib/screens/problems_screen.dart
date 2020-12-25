import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reachout/home.dart';
import 'package:reachout/screens/add_problems.dart';
import 'package:reachout/widgets/loading_indicator.dart';
import 'package:reachout/widgets/problems.dart';

class ProblemsScreen extends StatefulWidget {
  @override
  _ProblemsScreenState createState() => _ProblemsScreenState();
}

class _ProblemsScreenState extends State<ProblemsScreen> {
  List<Problems> problemPosts;
  List<Problems> problemsToDisplay;
  TextEditingController searchController = TextEditingController();

  Future<void> getProblems() async {
    print('jdbnjcaldcja');
    QuerySnapshot snapshot = await problemsRef.getDocuments();
    print(snapshot.documents.length);
    List<Problems> problems =
        snapshot.documents.map((doc) => Problems.fromDocument(doc)).toList();
    setState(() {
      problemPosts = problems;
      problemsToDisplay = problemPosts;
    });
  }

  buildProblems() {
    if (problemsToDisplay == null) {
      return LoadingIndicator();
    } else if (problemsToDisplay.isEmpty) {
      return Center(child: Text(''));
    } else {
      return Column(
        children: [
          ...problemsToDisplay,
        ],
      );
    }
  }

  Widget showProblems() {
    return Container(
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () => getProblems(),
        child: buildProblems(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getProblems();
  }

  addProblems() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddProblems(),
      ),
    );
  }

  searchProblem(String query) {
    if (query.trim() == '' || query == null) {
      setState(() {
        problemsToDisplay = problemPosts;
      });
    } else {
      query = query.toLowerCase();
      setState(() {
        problemsToDisplay = problemPosts.where((problem) {
          String heading = problem.heading.toLowerCase();
          return heading.contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addProblems,
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white10,
      appBar: PreferredSize(
        child: AppBar(
          centerTitle: true,
          toolbarOpacity: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: const Radius.circular(7),
            ),
          ),
          primary: true,
          title: Text('questions'.toUpperCase(),
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(244, 248, 245, 1),
                  letterSpacing: 1.2)),
        ),
        preferredSize: const Size.fromHeight(55),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (query) => searchProblem(query),
                    controller: searchController,
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      focusColor: Colors.red,
                      hintText: 'Search for questions',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                showProblems(),
              ],
            ),
          ),
          onRefresh: getProblems,
        ),
      ),
    );
  }
}
