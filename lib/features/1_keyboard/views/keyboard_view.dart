import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'list_commands.dart';

class Keyboard extends StatelessWidget {
  final KeyboardSettingController keyboardSettingController;
  final HomeController homeController;
  final PanelDashBoard panelDashBoard;
  const Keyboard(
      {super.key,
      required this.keyboardSettingController,
      required this.homeController,
      required this.panelDashBoard});

  @override
  Widget build(BuildContext context) {
    late double lengthScreen;

    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        lengthScreen = MediaQuery.of(context).size.height;
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        lengthScreen = MediaQuery.of(context).size.width;
      }
      //SystemChannels.textInput.invokeMethod('TextInput.hide');
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      const double padding = 8;
      double spaceCompensation =
          padding * keyboardSettingController.visibleAmountBtn;
      spaceCompensation = spaceCompensation * 2;
      spaceCompensation = spaceCompensation;
      if (orientation == Orientation.landscape) {
        spaceCompensation = spaceCompensation + 15;
      } else {
          spaceCompensation = spaceCompensation +
              35 +
              keyboardSettingController.spaceDebugSessionSelector;
      }
      lengthScreen = lengthScreen - spaceCompensation;
      double sizeBtn =
          lengthScreen / keyboardSettingController.visibleAmountBtn;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )),
                height:
                    keyboardSettingController.spaceDebugSessionSelector - 20,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 4, left: 20, right: 16),
                  child: (keyboardSettingController.listSessionName.isNotEmpty)?DropdownButton<String>(
                    dropdownColor: keyboardSettingController.darkMode
                        ? Colors.black87
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    underline: const SizedBox.shrink(),
                    icon: Icon(
                      Icons.arrow_drop_down_sharp,
                      color:
                          (keyboardSettingController.listSessionName.length == 1)
                              ? Colors.transparent
                              : Colors.white,
                    ),
                    value: keyboardSettingController.listSessionName[0],
                    onChanged: (String? newValue) {
                      Map<String, dynamic> command = {
                        "debugSessionNameSelector": newValue
                      };
                      panelDashBoard.sentCommand(
                          command, keyboardSettingController);
                    },
                    items: keyboardSettingController.listSessionName
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: keyboardSettingController.darkMode
                                    ? Colors.blueAccent
                                    : Colors.black),
                          ),
                        ),
                      );
                    }).toList(),
                    isExpanded: false,
                  ):Text("VsCode Keyboard",style: TextStyle(
                                color: keyboardSettingController.darkMode
                                    ? Colors.white70
                                    : Colors.black87)),
                ),
              ),
            ),
          Expanded(
            child: ListCommands(
              padding: padding,
              sizeBtn: sizeBtn,
              panelDashBoard: panelDashBoard,
              orientation: orientation,
              keyboardSettingController: keyboardSettingController,
              homeController: homeController,
            ),
          ),
        ],
      );
    });
  }
}
