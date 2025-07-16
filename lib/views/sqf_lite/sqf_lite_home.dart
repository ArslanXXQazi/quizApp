import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studypool/common_widget/listening_container.dart';
import 'package:studypool/views/sqf_lite/non_verbal_question/non_verbal_question.dart';
import 'package:studypool/views/sqf_lite/verbal_questions/verbal_question.dart';

class SqfLite extends StatelessWidget {
  const SqfLite({super.key});

  @override
  Widget build(BuildContext context) {
    final  screenWidth = MediaQuery.sizeOf(context).width;
    final   screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: screenWidth*.03,vertical: screenHeight*.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ListeningContainer(
              onTap: ()
              {
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>VerbalQuestion()));
              },
              text: "verbal Question",
              color: Colors.green,
              width: double.infinity,
            ),
            SizedBox(height: screenHeight*.03),
            ListeningContainer(
              onTap: ()
              {
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>NonVerbalQuestion()));
              },
              text: "Non-verbal Question",
              color: Colors.blue,
              width: double.infinity,
            ),
          ],),
      ),
    );
  }
}
