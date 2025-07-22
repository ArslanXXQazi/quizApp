import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/views/local_list/listening4_view.dart';
import '../../common_widget/text_widget.dart';
import '../../models/data.dart';
import 'local_list_controller.dart';

class Listening3View extends StatelessWidget {
  const Listening3View({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final LocalListController controller = Get.find<LocalListController>();
    final questions = listening3Questions;
    final questionOffset = listening1Questions.length + listening2Questions.length; // For continuous numbering
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * .06, horizontal: screenWidth * .02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){Get.back();}, icon:Icon(Icons.arrow_back_ios,color: Colors.white,)),
                      Row(children: [
                        CircleAvatar(
                          radius: screenWidth * .04,
                          backgroundColor: Colors.orange.shade700,
                          child: Icon(Icons.headphones, color: Colors.white, size: screenHeight * .025),
                        ),
                        SizedBox(width: screenWidth * .02),
                        GreenText(
                          text: "Listening",
                          fontSize: 20,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w600,
                        )
                      ]),
                      Container(
                        height: screenHeight * .045,
                        width: screenWidth * .2,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: GreenText(
                            text: "50:00",
                            textColor: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * .14),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * .03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GreenText(
                        text: "C.Listen to the passage and tell whether the following statements are true or false",
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: screenHeight * .02),
                      ...List.generate(questions.length, (qIndex) {
                        final q = questions[qIndex];
                        return Container(
                          margin: EdgeInsets.only(bottom: screenHeight * .03),
                          child: Row(children: [
                            GreenText(text: "${questionOffset + qIndex + 1}. ",),
                            Expanded(
                              child: GreenText(
                                text: q.questionText,
                                textAlign: TextAlign.start,
                                fontSize: 14,
                              ),
                            ),
                            Obx(() => Row(
                              children: List.generate(2, (optIdx) {
                                final option = q.options![optIdx];
                                final isSelected = controller.listening3Selected[qIndex] == option;
                                return Container(
                                  height: screenHeight * .05,
                                  width: screenWidth * .15,
                                  margin: EdgeInsets.only(left: screenWidth * .01),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.green : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectListening3(qIndex, option);
                                    },
                                    child: Center(
                                      child: GreenText(
                                        text: option,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        textColor: isSelected ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            )),
                          ]),
                        );
                      }),
                      SizedBox(height: screenHeight * .05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){Get.back();}, icon:Icon(Icons.arrow_back_ios)),
                          IconButton(onPressed: (){Get.to(Listening4View());}, icon:Icon(Icons.arrow_forward_ios_outlined)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],),
    );
  }
}
