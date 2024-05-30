import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vsckeyboard/common/class_functions/grid_controller.dart';
import 'package:vsckeyboard/common/widgets/tab_container.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

class TabCommandGroup extends StatelessWidget {
  const TabCommandGroup({
    super.key,
    required this.keyboardSettingController,
    required this.mainController,
    required this.width,
    required this.height,
    required this.widgetFooter,
    required this.gridController,
    this.widgetHeader,
  });

  final KeyboardSettingController keyboardSettingController;
  final MainController mainController;
  final double width;
  final double height;
  final Widget widgetFooter;
  final Widget? widgetHeader;

  final GridController gridController;
  @override
  Widget build(BuildContext context) {
    return (gridController.commandGroups.isNotEmpty)
        ? Container(
            constraints: const BoxConstraints(
              minHeight: 450,
            ),
            width: width,
            height: (Platform.isAndroid || Platform.isIOS)
                ? height * .6
                : height * .6,
            child: TabCommands(
              mainController: mainController,
              gridController: gridController,
              width: width,
              height: height,
              keyboardSettingCtrl: keyboardSettingController,
              widgetFooter: widgetFooter,
              widgetHeader: widgetHeader,
            ),
          )
        : const SizedBox.shrink();
  }
}
