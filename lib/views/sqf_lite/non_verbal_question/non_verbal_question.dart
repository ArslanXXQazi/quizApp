import 'package:flutter/material.dart';
import 'package:studypool/common_widget/listening_container.dart';

class NonVerbalQuestion extends StatelessWidget {
  const NonVerbalQuestion({super.key});

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
              onTap: () {

              },
              text: "Enter Test",
              color: Colors.orange.shade700,
              width: double.infinity,
            ),
            SizedBox(height: screenHeight*.03),
            ListeningContainer(
              onTap: ()
              {

              },
              text: "Add Questions",
              color: Colors.blue,
              width: double.infinity,
            ),
          ],),
      ),
    );
  }
}
