import 'package:flutter/material.dart';
import 'package:studypool/common_widget/text_widget.dart';

class AddVerbalQuestion extends StatelessWidget {
  const AddVerbalQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GreenText(
          text: "Enter Questions",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.all(screenWidth * 0.04),
        child: Column(children: [

        ],),
      ),
    );
  }
}
