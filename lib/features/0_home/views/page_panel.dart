import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fkeys/features/0_home/controllers/home_controller.dart';
import 'package:fkeys/features/1_keyboard/controllers/main_controller.dart';
import 'package:fkeys/features/1_keyboard/views/keyboard_view.dart';
import 'package:fkeys/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';
import 'package:fkeys/features/3_key_settings/views/key_settings_page.dart';
import 'package:fkeys/features/4_all_commands/views/page_all_commands.dart';

class PageViewCustom extends StatefulWidget {
  final KeyboardSettingController keyboardSettingCtrl;
  final HomeController homeController;
  final PageController pageController;
  final MainController mainController;
  final String keyBoardName;

  const PageViewCustom(
      {super.key,
      required this.keyboardSettingCtrl,
      required this.pageController,
      required this.keyBoardName,
      required this.homeController,
      required this.mainController});

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
        KeySettings(
          keyboardSettingController: widget.keyboardSettingCtrl,
          mainController: widget.mainController,
        ),
        Keyboard(
          keyboardSettingController: widget.keyboardSettingCtrl,
          homeController: widget.homeController,
          mainController: widget.mainController,
        ),
        LayoutBuilder(
          builder: (context, c) {
            return AllCommands(
                widthTabContainer: MediaQuery.of(context).size.width - 42,
                keyboardSettingController: widget.keyboardSettingCtrl,
                mainController: widget.mainController);
          }
        )
      ],
    );
  }
}
