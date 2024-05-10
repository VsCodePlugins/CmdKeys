import 'package:flutter/material.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/1_keyboard/views/page_btn_actions.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import '../../2_keyboard_setting/views/page_keyboard_settings.dart';

class PageViewCustom extends StatefulWidget {
  final KeyboardSettingController keyboardSettingCtrl;
  final HomeController homeController;
    final PageController pageController;
    final String keyBoardName;

   const PageViewCustom({super.key, required this.keyboardSettingCtrl
    , required this.pageController, required this.keyBoardName, required this.homeController});

  @override
  State<PageViewCustom> createState() => _PageViewCustomState();
}

class _PageViewCustomState extends State<PageViewCustom> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: widget.pageController,
       
        scrollDirection: Axis.horizontal, 
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(color: Colors.green,),
          ConsumerListCommand(keyboardSettingController: widget.keyboardSettingCtrl,homeController:widget.homeController ,),
          CommandsSettings(keyBoardName:widget.keyBoardName),
          ],
       
      ),
    );
  }
}

