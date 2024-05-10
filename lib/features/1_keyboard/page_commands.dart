import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

import 'controllers/dashboard.dart';
import 'views/list_commands.dart';

int visibleAmountBtn = 8;
double lengthScreen = 1;



class ConsumerListCommand extends StatelessWidget {
  final KeyboardSettingController keyboardSettingController;
  final HomeController homeController;
  final bool isDarkMode = false;
  const ConsumerListCommand({super.key, required this.keyboardSettingController, required this.homeController,
    });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        lengthScreen = MediaQuery.of(context).size.height;
      } else {
        lengthScreen = MediaQuery.of(context).size.width;
      }
      const double padding = 8;
      double spaceCompensation = padding * visibleAmountBtn;
      spaceCompensation = spaceCompensation * 2;
      spaceCompensation = spaceCompensation;
      if (orientation == Orientation.landscape) {
        spaceCompensation = spaceCompensation + 15;
      } else {
        spaceCompensation = spaceCompensation + 35;
      }
      lengthScreen = lengthScreen - spaceCompensation;
      double sizeBtn = lengthScreen / visibleAmountBtn;

      return Consumer<PanelDashBoard>(
          builder: (context, panelDashBoard, child) {
        return ListCommands(
          homeController: homeController,
            padding: padding,
            sizeBtn: sizeBtn,
            panelDashBoard: panelDashBoard,
            orientation: orientation,
            keyboardSettingController: keyboardSettingController
            
            );
      });
    });
  }
}