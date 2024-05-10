import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

import '../controllers/dashboard.dart';
import 'list_commands.dart';




class ConsumerListCommand extends StatelessWidget {
  final KeyboardSettingController keyboardSettingController;

  const ConsumerListCommand({super.key, required this.keyboardSettingController
    });

  @override
  Widget build(BuildContext context) {
    late double lengthScreen ;

    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        lengthScreen = MediaQuery.of(context).size.height;
      } else {
        lengthScreen = MediaQuery.of(context).size.width;
      }
      const double padding = 8;
      double spaceCompensation = padding * keyboardSettingController.visibleAmountBtn;
      spaceCompensation = spaceCompensation * 2;
      spaceCompensation = spaceCompensation;
      if (orientation == Orientation.landscape) {
        spaceCompensation = spaceCompensation + 15;
      } else {
        spaceCompensation = spaceCompensation + 35;
      }
      lengthScreen = lengthScreen - spaceCompensation;
      double sizeBtn = lengthScreen / keyboardSettingController.visibleAmountBtn;

      return Consumer<PanelDashBoard>(
          builder: (context, panelDashBoard, child) {
        return ListCommands(
            padding: padding,
            sizeBtn: sizeBtn,
            panelDashBoard: panelDashBoard,
            orientation: orientation,
            keyboardSettingController: keyboardSettingController,
            );
      });
    });
  }
}