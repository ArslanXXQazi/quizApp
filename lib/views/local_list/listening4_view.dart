import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import '../../common_widget/text_widget.dart';
import '../../models/data.dart';
import 'local_list_controller.dart';

class Listening4View extends StatefulWidget {
  const Listening4View({super.key});

  @override
  State<Listening4View> createState() => _Listening4ViewState();
}

class _Listening4ViewState extends State<Listening4View> {
  late List<TextEditingController> textControllers;
  final LocalListController controller = Get.find<LocalListController>();
  final questions = listening4Questions;

  @override
  void initState() {
    super.initState();
    textControllers = List.generate(
      questions.length,
      (i) => TextEditingController(text: controller.listening4Answers[i] ?? ""),
    );
  }

  @override
  void dispose() {
    for (final c in textControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final questionOffset = listening1Questions.length + listening2Questions.length + listening3Questions.length; // For continuous numbering
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
                        text: "D. Listen to the dialogue and complete the following sentences",
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: screenHeight * .02),
                      ...List.generate(questions.length, (qIndex) {
                        final q = questions[qIndex];
                        return Container(
                          margin: EdgeInsets.only(bottom: screenWidth * .03),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GreenText(text: "${questionOffset + qIndex + 1}.",),
                              Expanded(
                                child: GreenText(
                                  text: q.beforeBlank ?? '',
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: screenWidth * .015),
                              SizedBox(
                                width: screenWidth * .2,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  controller: textControllers[qIndex],
                                  onChanged: (val) {
                                    controller.setListening4(qIndex, val);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.green, width: 1),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * .015),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GreenText(
                                      text: q.afterBlank ?? '',
                                      fontSize: 13,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: screenHeight * .05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){Get.back();}, icon:Icon(Icons.arrow_back_ios)),
                          IconButton(onPressed: (){
                            // Combine all user answers and questions
                            final allQuestions = [
                              ...listening1Questions,
                              ...listening2Questions,
                              ...listening3Questions,
                              ...listening4Questions,
                            ];
                            final userAnswers = <Map<String, String>>[];
                            final c = controller;
                            for (int i = 0; i < listening1Questions.length; i++) {
                              userAnswers.add({
                                'userAnswer': c.listening1Selected[i] ?? '',
                                'correctAnswer': listening1Questions[i].correctAnswer ?? '',
                              });
                            }
                            for (int i = 0; i < listening2Questions.length; i++) {
                              userAnswers.add({
                                'userAnswer': c.listening2Selected[i] ?? '',
                                'correctAnswer': listening2Questions[i].correctAnswer ?? '',
                              });
                            }
                            for (int i = 0; i < listening3Questions.length; i++) {
                              userAnswers.add({
                                'userAnswer': c.listening3Selected[i] ?? '',
                                'correctAnswer': listening3Questions[i].correctAnswer ?? '',
                              });
                            }
                            for (int i = 0; i < listening4Questions.length; i++) {
                              userAnswers.add({
                                'userAnswer': c.listening4Answers[i] ?? '',
                                'correctAnswer': listening4Questions[i].correctAnswer ?? '',
                              });
                            }
                            Get.to(() => DetailView(userAnswers: userAnswers, questions: allQuestions));
                          }, icon:Icon(Icons.arrow_forward_ios_outlined)),
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
