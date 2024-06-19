import 'package:flutter/material.dart';

class MyPopUp extends StatefulWidget {
  const MyPopUp({super.key});

  @override
  State<MyPopUp> createState() => MyPopUpState();
}

class MyPopUpState extends State<MyPopUp> {
  bool allow = false;
  String contentText = "";
  Color textColor = const Color.fromRGBO(0, 0, 0, 0);
  Color bckgColor = const Color.fromRGBO(0, 0, 0, 0);

  void changeAllow() {
    if (allow) {
      setState(() {
        allow = false;
      });
    } else {
      setState(() {
        allow = true;
      });
    }
  }

  void isCorrect(bool submit, String newText) {
    if (submit) {
      setState(() {
        textColor = const Color.fromARGB(255, 15, 94, 8);
        bckgColor = const Color.fromARGB(135, 68, 155, 10);
        contentText = newText;
      });
    } else {
      setState(() {
        textColor = const Color.fromRGBO(255, 0, 0, 1);
        bckgColor = const Color.fromRGBO(255, 62, 62, 0.541);
        contentText = newText;
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Visibility(
      visible: allow,
      child: Container( 
        decoration: BoxDecoration(
          color: bckgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: textColor,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            contentText,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ), 
    );
  }
}