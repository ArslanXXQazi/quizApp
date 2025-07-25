import 'package:flutter/material.dart';
import 'package:studypool/common_widget/text_widget.dart';

class ListeningContainer extends StatelessWidget {

  final VoidCallback onTap;
  final String text;
  final Color color;
  final double? height;
  final double? width;

   ListeningContainer({super.key,
     required this.onTap,
     required this.text,
     required this.color,
     this.height,
     this.width,
   });

  @override
  Widget build(BuildContext context) {
    final  screenWidth = MediaQuery.sizeOf(context).width;
    final   screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height?? screenHeight*.2,
        width:  width?? screenWidth*.3,
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
