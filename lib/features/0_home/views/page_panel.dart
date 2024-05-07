import 'package:flutter/material.dart';
import 'package:vsckeyboard/features/1_keyboard/views/page_commands.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import '../../2_keyboard_setting/views/page_settings.dart';

class PageViewCustom extends StatefulWidget {
  final KeyboardSettingController keyboardSettingCtrl;
    final PageController pageController;
    final String keyBoardName;

   const PageViewCustom({super.key, required this.keyboardSettingCtrl
    , required this.pageController, required this.keyBoardName});

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
          ConsumerListCommand(keyboardSettingController: widget.keyboardSettingCtrl,),
          CommandsSettings(keyBoardName:widget.keyBoardName),],
      ),
    );
  }
}

