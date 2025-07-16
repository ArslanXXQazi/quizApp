import 'package:flutter/material.dart';
import 'package:studypool/common_widget/listening_container.dart';
import 'package:studypool/common_widget/text_widget.dart';
class AddQuestionNonVerbal extends StatelessWidget {
  const AddQuestionNonVerbal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GreenText(
          text: "Enter Questions",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Column(children: [
        GreenText(
          text: "Q1) ",
        )
      ],),
    );
  }
}
