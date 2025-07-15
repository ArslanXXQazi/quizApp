import 'package:flutter/material.dart';
import 'package:studypool/common_widget/text_widget.dart';

class ListeningContainer extends StatelessWidget {

  final VoidCallback onTap;
  final String text;
  final Color color;

   ListeningContainer({super.key,
     required this.onTap,
     required this.text,
     required this.color,
   });

  @override
  Widget build(BuildContext context) {
    final  screenWidth = MediaQuery.sizeOf(context).width;
    final   screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight*.2,
        width: screenWidth*.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        child: Center(child: GreenText(
          text: text,
          textColor: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        )),
      ),
    );
  }
}
