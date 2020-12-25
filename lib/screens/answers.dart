import 'package:flutter/material.dart';
import 'package:reachout/home.dart';
import 'package:reachout/widgets/answer.dart';
import 'package:reachout/widgets/loading_indicator.dart';

class Answers extends StatefulWidget {
  final String problemId;
  Answers({this.problemId});
  @override
  _AnswersState createState() => _AnswersState(
        problemId: this.problemId,
      );
}

class _AnswersState extends State<Answers> {
  TextEditingController answerController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String problemId;
  _AnswersState({this.problemId});

  buildAnswers() {
    return StreamBuilder(
      stream: answersRef
          .document(problemId)
          .collection('answers')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        }
        List<Answer> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(Answer.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addAnswer() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      answersRef.document(problemId).collection('answers').add({
        'firstName': currentUser.firstName,
        'answer': answerController.text,
        'timestamp': timestamp,
        'userId': currentUser.id,
      });
      answerController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildAnswers(),
          ),
          // Divider(),
          ListTile(
            title: Form(
              key: _formKey,
              child: TextFormField(
                controller: answerController,
                decoration: InputDecoration(
                  labelText: 'Write an Answer',
                ),
                validator: (value) {
                  if (value == null || value.trim() == '') {
                    return "";
                  }
                  return null;
                },
              ),
            ),
            trailing: OutlineButton(
              onPressed: addAnswer,
              child: Text('Post'),
              borderSide: BorderSide.none,
            ),
          ),
        ],
      ),
    );
  }
}
