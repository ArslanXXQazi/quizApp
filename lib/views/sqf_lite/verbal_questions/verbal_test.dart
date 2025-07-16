import 'package:flutter/material.dart';
import 'package:studypool/common_widget/text_widget.dart';
class VerbalTest extends StatelessWidget {
  const VerbalTest({super.key});

  @override
  Widget build(BuildContext context) {
    final  screenWidth = MediaQuery.sizeOf(context).width;
    final   screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const GreenText(
          text: "Verbal Test",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02,vertical: screenHeight*.03),
        child: Column(children: [

        ],),
      ),
    );
  }
}
