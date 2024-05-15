import 'package:flutter/material.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/1_keyboard/views/keyboard_view.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/views/page_keyboard_settings.dart';
import 'package:vsckeyboard/features/3_key_settings/views/key_settings_page.dart';

class PageViewCustom extends StatefulWidget {
  final KeyboardSettingController keyboardSettingCtrl;
  final HomeController homeController;
    final PageController pageController;
    final PanelDashBoard panelDashBoard;
    final String keyBoardName;

   const PageViewCustom({super.key, required this.keyboardSettingCtrl
    , required this.pageController, required this.keyBoardName, required this.homeController, required this.panelDashBoard});

  @override
  State<PageViewCustom> createState() => _PageViewCustomState();
}

class _PageViewCustomState extends State<PageViewCustom> {

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: widget.pageController,
        scrollDirection: Axis.horizontal, 
        physics: const NeverScrollableScrollPhysics(),
        children: [
           KeySettings(keyboardSettingController: widget.keyboardSettingCtrl,),
          Keyboard(keyboardSettingController: widget.keyboardSettingCtrl,
                   homeController:widget.homeController,
                   panelDashBoard: widget.panelDashBoard,),

          KeyboardSettings(keyBoardName:widget.keyBoardName),
          ],
       
      
    );
  }
}


