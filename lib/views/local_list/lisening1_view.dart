import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/images/app_images.dart';
import 'package:studypool/views/local_list/listening2_view.dart';
import '../../common_widget/text_widget.dart';
import '../../models/data.dart';
import 'local_list_controller.dart';
import 'package:audioplayers/audioplayers.dart';

class Lisening1View extends StatefulWidget {
  const Lisening1View({super.key});

  @override
  State<Lisening1View> createState() => _Lisening1ViewState();
}

class _Lisening1ViewState extends State<Lisening1View> with RouteAware {
  final LocalListController controller = Get.put(LocalListController());
  final List questions = listening1Questions;
  final AudioPlayer _audioPlayer = AudioPlayer();
  OverlayEntry? _dropdownOverlay;
  final RxnInt _activeBoxIndex = RxnInt();
  final List<GlobalKey> boxKeys = List.generate(5, (_) => GlobalKey());
  bool _audioPlayed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_audioPlayed) {
      _playAudio();
      _audioPlayed = true;
    }
  }

  Future<void> _playAudio() async {
    if (questions.isNotEmpty && questions[0].audioPath != null && questions[0].audioPath!.isNotEmpty) {
      await _audioPlayer.play(AssetSource(questions[0].audioPath!.replaceFirst('assets/audio/', '')));
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
  }

  void _showDropdown(int index) {
    _removeDropdown();
    final key = boxKeys[index];
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final overlay = Overlay.of(context);

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy - (size.height * 6.5), // open upwards
          width: size.width,
          child: Material(
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(6, (optionIdx) {
                final option = String.fromCharCode(65 + optionIdx); // A-F
                return InkWell(
                  onTap: () {
                    controller.selectListening1(index, option);
                    _removeDropdown();
                  },
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: GreenText(text: option),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
    overlay.insert(_dropdownOverlay!);
    _activeBoxIndex.value = index;
  }

  void _removeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
    _activeBoxIndex.value = null;
  }

  @override
  void dispose() {
    _removeDropdown();
    _stopAudio();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _navigateBack() {
    _stopAudio();
    Get.back();
  }

  void _navigateNext() {
    _stopAudio();
    Get.to(Listening2View());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return WillPopScope(
      onWillPop: () async {
        _stopAudio();
        return true;
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: _removeDropdown,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * .06,
                    horizontal: screenWidth * .02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: _navigateBack,
                            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: screenWidth * .04,
                                backgroundColor: Colors.orange.shade700,
                                child: Icon(
                                  Icons.headphones,
                                  color: Colors.white,
                                  size: screenHeight * .025,
                                ),
                              ),
                              SizedBox(width: screenWidth * .02),
                              GreenText(
                                text: "Listening",
                                fontSize: 20,
                                textColor: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
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
                          ),
                        ],
                      ),
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
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * .03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GreenText(
                            text: "A.Listen and choose the right picture",
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: screenHeight * .02),
                            // Images (A-F) in 3 rows of 2
                          Row(
                            children: [
                                ImageContainer(image: questions[0].optionImages![0], option: "A"),
                                ImageContainer(image: questions[0].optionImages![1], option: "B"),
                            ],
                          ),
                          Row(
                            children: [
                                ImageContainer(image: questions[0].optionImages![2], option: "C"),
                                ImageContainer(image: questions[0].optionImages![3], option: "D"),
                            ],
                          ),
                          Row(
                            children: [
                                ImageContainer(image: questions[0].optionImages![4], option: "E"),
                                ImageContainer(image: questions[0].optionImages![5], option: "F"),
                            ],
                          ),
                          SizedBox(height: screenHeight * .02),
                            // 5 questions, each with a number and dropdown
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: List.generate(5, (index) {
                                  return Row(
                              children: [
                                      OptionContainer(option: "${index + 1}"),
                                SizedBox(width: screenWidth * .02),
                                     Obx(() => GestureDetector(
                                           key: boxKeys[index],
                                           onTap: () {
                                             _showDropdown(index);
                                           },
                                           child: Container(
                                             height: screenHeight * .03,
                                             width: screenWidth * .1,
                                             decoration: BoxDecoration(
                                               border: Border.all(color: Colors.black),
                                               color: controller.listening1Selected[index] != null
                                                   ? Colors.green
                                                   : Colors.grey[100],
                                             ),
                                             child: Center(
                                               child: GreenText(
                                                 text: controller.listening1Selected[index] ?? "",
                                                 textColor: controller.listening1Selected[index] != null
                                                     ? Colors.white
                                                     : Colors.black,
                                                 fontWeight: FontWeight.bold,
                                               ),
                                             ),
                                           ),
                                     )),
                                SizedBox(width: screenWidth * .02),
                                  ],
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: screenHeight * .05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: _navigateBack,
                                icon: Icon(Icons.arrow_back_ios),
                              ),
                              IconButton(
                                  onPressed: _navigateNext,
                                icon: Icon(Icons.arrow_forward_ios_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String image;
  final String option;

  const ImageContainer({super.key, required this.image, required this.option});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Expanded(
      child: Column(
        children: [
          Container(
            height: screenHeight * .18,
            child: Image(image: AssetImage(image)),
          ),
          SizedBox(height: screenHeight * .005),
          GreenText(text: option),
        ],
      ),
    );
  }
}

class OptionContainer extends StatelessWidget {
  final String option;

  const OptionContainer({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      height: screenHeight * .03,
      width: screenWidth * .1,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Center(child: GreenText(text: option)),
    );
  }
}
