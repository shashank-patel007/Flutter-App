import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_app/components/AnswerButton.dart';
import 'package:quiz_app/components/HeadingText.dart';
import 'package:quiz_app/components/QuestionText.dart';

import 'ques.dart';

//APP CONSTANTS
var _THEME_COLOUR_ = const Color(0xff0A3D62);

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int totalQues = 15;
  int solvedQues = 0;
  String nextQue = "";
  String quiz_status = "START";
  String score = "";
  String op1, op2, op3, op4, answer;
  bool isQuizStarted = false;
  int finalScore = 0;
  List<int> solvedQuesIndexes = [];

  void check_ans(String value) {
    print(value);
    setState(() {
      solvedQues += 1;
      if (value == answer) {
        finalScore += 1;
      }
      if (solvedQues == totalQues) {
        isQuizStarted = false;
        score = "SCORE: $finalScore/$totalQues";
        nextQue = "";
        op1 = "";
        op2 = "";
        String message = "";
        if (finalScore >= 5 && finalScore <= 8) {
          message += "Your brain is functioning okay.";
        } else if (finalScore <= 12 && finalScore >= 9) {
          message += "Your brain is in danger. Check your diet today.";
        } else {
          message +=
              "Your brain is running on empty. You should see your doctor.";
        }
        showAlertDialog(context, message);
        message = "";
      } else {
        var index = Random().nextInt(QUES.length);
        while (solvedQuesIndexes.contains(index)) {
          index = Random().nextInt(QUES.length);
        }
        solvedQuesIndexes.add(index);
        List<String> ans = QUES[index]['answers'];
        nextQue = QUES[index]['question'];
        op1 = ans[0];
        op2 = ans[1];
        answer = ans[QUES[index]['correctIndex']];
      }
    });
  }

  void start_quiz() {
    print("In");
    setState(() {
      finalScore = 0;
      solvedQues = 0;
      isQuizStarted = true;
      score = "";
      quiz_status = "RESTART";
      solvedQuesIndexes = [];
      var index = Random().nextInt(QUES.length);
      while (solvedQuesIndexes.contains(index)) {
        index = Random().nextInt(QUES.length);
      }
      solvedQuesIndexes.add(index);
      List<String> ans = QUES[index]['answers'];
      nextQue = QUES[index]['question'];
      op1 = ans[0];
      op2 = ans[1];
      answer = ans[QUES[index]['correctIndex']];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _THEME_COLOUR_,
        title: Text(
          "QUIZ",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      // backgroundColor: _THEME_BG_COLOUR_,
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  HeadingText(
                    "Questions: $solvedQues/$totalQues".toUpperCase(),
                  ),
                  QuestionText("$nextQue", screen_width),
                  //Answer Button
                  Column(
                    children: <Widget>[
                      AnswerButton(op1, isQuizStarted, check_ans, screen_width),
                      AnswerButton(op2, isQuizStarted, check_ans, screen_width),
                    ],
                  ),
                  HeadingText("$score".toUpperCase()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: start_quiz,
                      color: Colors.green[800],
                      minWidth: screen_width,
                      height: 50.0,
                      child: Text(
                        "$quiz_status",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context, message) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Your Report"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
