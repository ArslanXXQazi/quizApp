import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studypool/common_widget/listening_container.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/listening_a_view/listening_a_view.dart';
import 'package:studypool/views/listening_b_view/listening_b_view.dart';
import 'package:studypool/views/listening_c_view/listening_c_view.dart';
import 'package:studypool/views/listening_d_view/listening_d_view.dart';
import 'package:get/get.dart';
import 'package:studypool/views/listening_a_view/listening_a_controller.dart';
import 'package:studypool/views/listening_b_view/listening_b_controller.dart';
import 'package:studypool/views/listening_c_view/listening_c_controller.dart';
import 'package:studypool/views/listening_d_view/listening_d_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
  final  screenWidth = MediaQuery.sizeOf(context).width;
  final   screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: screenWidth*.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              Expanded(
                child: ListeningContainer(
                    onTap: () {
                      Get.delete<ListeningAController>();
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>ListeningAView()));
                    },
                    text: "Listening A",
                    color: Colors.blue
                ),
              ),
              SizedBox(width: screenWidth*.03),
              Expanded(
                child: ListeningContainer(
                    onTap: () {
                      Get.delete<ListeningBController>();
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>ListeningBView()));
                    },
                    text: "Listening B",
                    color: Colors.green
                ),
              ),
            ],),
            SizedBox(height: screenHeight*.03,),
            Row(children: [
              Expanded(
                child: ListeningContainer(
                    onTap: () {
                      Get.delete<ListeningCController>();
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>ListeningCView()));
                    },
                    text: "Listening C",
                    color: Colors.orange
                ),
              ),
              SizedBox(width: screenWidth*.03),
              Expanded(
                child: ListeningContainer(
                    onTap: () {
                      Get.delete<ListeningDController>();
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>ListeningDView()));
                    },
                    text: "Listening D",
                    color: Colors.pink
                ),
              ),
            ],)
        ],),
      ),
    );
  }
}
