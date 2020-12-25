import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/screens/answers.dart';
import 'package:reachout/widgets/answer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loading_indicator.dart';

class Problems extends StatefulWidget {
  final String problemId;
  final String ownerId;
  final String username;
  final String heading;
  final String description;
  final String mediaUrl;
  final dynamic upvotes;
  final dynamic downvotes;

  Problems({
    this.problemId,
    this.ownerId,
    this.username,
    this.heading,
    this.description,
    this.mediaUrl,
    this.upvotes,
    this.downvotes,
  });

  factory Problems.fromDocument(DocumentSnapshot doc) {
    return Problems(
      problemId: doc['problemId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      heading: doc['heading'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      upvotes: doc['upvotes'],
      downvotes: doc['downvotes'],
    );
  }

  int getVoteCount(upvotes, downvotes) {
    if (upvotes == null && downvotes == null) {
      return 0;
    }
    int count = 0;
    upvotes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    downvotes.values.forEach((val) {
      if (val == true) {
        count -= 1;
      }
    });
    return count;
  }

  @override
  _ProblemsState createState() => _ProblemsState(
        problemId: this.problemId,
        ownerId: this.ownerId,
        username: this.username,
        heading: this.heading,
        description: this.description,
        mediaUrl: this.mediaUrl,
        upvotes: this.upvotes,
        downvotes: this.downvotes,
        voteCount: getVoteCount(
          this.upvotes,
          this.downvotes,
        ),
      );
}

class _ProblemsState extends State<Problems> {
  _ProblemsState({
    this.problemId,
    this.ownerId,
    this.username,
    this.description,
    this.mediaUrl,
    this.heading,
    this.upvotes,
    this.downvotes,
    this.voteCount,
  });
  final String problemId;
  final String ownerId;
  final String username;
  final String description;
  final String heading;
  final String mediaUrl;
  int voteCount;
  Map upvotes;
  Map downvotes;
  bool isUpvoted;
  bool isDownvoted;
  int numberOfComments;

  handleUpvote() {
    bool _isUpvoted = upvotes[currentUser.id] == true;
    bool _isDownvoted = downvotes[currentUser.id] == true;
    if (_isUpvoted) {
      problemsRef
          .document(problemId)
          .updateData({'upvotes.${currentUser.id}': false});
      setState(() {
        voteCount -= 1;
        isUpvoted = false;
        upvotes[currentUser.id] = false;
      });
    } else if (!_isUpvoted) {
      problemsRef
          .document(problemId)
          .updateData({'upvotes.${currentUser.id}': true});
      setState(() {
        voteCount += 1;
        isUpvoted = true;
        upvotes[currentUser.id] = true;
      });
      if (_isDownvoted) {
        problemsRef
            .document(problemId)
            .updateData({'downvotes.${currentUser.id}': false});
        setState(() {
          voteCount += 1;
          isDownvoted = false;
          downvotes[currentUser.id] = false;
        });
      }
    }
  }

  handleDownvote() {
    bool _isDownvoted = downvotes[currentUser.id] == true;
    bool _isUpvoted = upvotes[currentUser.id] == true;
    if (_isDownvoted) {
      problemsRef
          .document(problemId)
          .updateData({'downvotes.${currentUser.id}': false});
      setState(() {
        voteCount += 1;
        isDownvoted = false;
        downvotes[currentUser.id] = false;
      });
    } else if (!_isDownvoted) {
      problemsRef
          .document(problemId)
          .updateData({'downvotes.${currentUser.id}': true});
      setState(() {
        voteCount -= 1;
        isDownvoted = true;
        downvotes[currentUser.id] = true;
      });
      if (_isUpvoted) {
        problemsRef
            .document(problemId)
            .updateData({'upvotes.${currentUser.id}': false});
        setState(() {
          voteCount -= 1;
          isUpvoted = false;
          upvotes[currentUser.id] = false;
        });
      }
    }
  }

  votingButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: isUpvoted
                ? Container(
                    child: Icon(Icons.arrow_upward_sharp,
                        size: 56, color: Color(0xFF880E4F)),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                : Icon(
                    Icons.arrow_upward_sharp,
                    size: 42,
                  ),
            onTap: handleUpvote,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              voteCount.toString(),
              style: TextStyle(fontSize: 26, color: Color(0xFF880E4F)),
            ),
          ),
          GestureDetector(
            child: isDownvoted
                ? Container(
                    child: Icon(Icons.arrow_downward_sharp,
                        size: 56, color: Color(0xFF880E4F)),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                : Icon(
                    Icons.arrow_downward_sharp,
                    size: 42,
                  ),
            onTap: handleDownvote,
          ),
        ],
      ),
    );
  }

  showAnswers() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Answers(
          problemId: problemId,
        ),
      ),
    );
  }

  buildAnswers() {
    return FutureBuilder(
      future: answersRef
          .document(problemId)
          .collection('answers')
          .orderBy('timestamp', descending: false)
          .limit(2)
          .getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        }
        List<Answer> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(Answer.fromDocument(doc));
        });
        // numberOfComments = comments.length;
        // print(comments.length);
        return Column(
          children: comments,
        );
      },
    );
  }

  commentSection() {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: EdgeInsets.fromLTRB(2, 0, 2, 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAnswers(),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 3, 0, 6),
            child: GestureDetector(
                onTap: showAnswers,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.add_sharp, size: 35),
                )
                // child: Text(
                //   'view all'.toUpperCase(),
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w500,
                //   ),
                // )
                ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isUpvoted = upvotes[currentUser.id] == true;
    isDownvoted = downvotes[currentUser.id] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
            color: Colors.grey[200],
            elevation: 0.5,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  votingButtons(),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(heading.toUpperCase(),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                letterSpacing: 0.5,
                              )),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(description,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            )),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
          commentSection(),
        ],
      ),
    );
  }
}
