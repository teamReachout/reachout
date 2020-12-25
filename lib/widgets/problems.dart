import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/screens/answers.dart';
import 'package:reachout/widgets/answer.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          child: Icon(
            isUpvoted ? Icons.arrow_circle_up : Icons.arrow_upward,
            size: 48,
          ),
          onTap: handleUpvote,
        ),
        Text(
          voteCount.toString(),
          style: TextStyle(fontSize: 44),
        ),
        GestureDetector(
          child: Icon(
            isDownvoted ? Icons.arrow_circle_down : Icons.arrow_downward,
            size: 48,
          ),
          onTap: handleDownvote,
        ),
      ],
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
        return Column(
          children: comments,
        );
      },
    );
  }

  commentSection() {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: showAnswers,
              child: Text(
                'All Answers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        buildAnswers()
      ],
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
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          votingButtons(),
          commentSection(),
        ],
      ),
    );
  }
}
