import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/common/constants.dart';
import 'package:vsckeyboard/common/model/command_types.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/common/class_functions/grid_controller.dart';
import 'package:vsckeyboard/common/widgets/icon_command.dart';
import 'package:vsckeyboard/common/widgets/standard_button.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'package:vsckeyboard/features/3_key_settings/controllers/key_settings_controller.dart';
import 'footer_assign_cmd.dart';
import 'name_text_field.dart';
import '../../../common/widgets/tab_command_group.dart';

class KeySettings extends StatelessWidget {
  final KeyboardSettingController keyboardSettingController;
  final MainController mainController;
  const KeySettings({
    super.key,
    required this.keyboardSettingController,
    required this.mainController,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KeySettingsController(
          currentBtnProperty: keyboardSettingController.currentBtnProperty,
          mainController: mainController),
      builder: (context, child) {
        KeySettingsController keySettingsCrl =
            context.watch<KeySettingsController>();
        return OrientationBuilder(builder: (context, orientation) {
          late double smallestReftDistance;
          if (orientation == Orientation.portrait) {
            smallestReftDistance = MediaQuery.of(context).size.width;
          } else {
            smallestReftDistance = MediaQuery.of(context).size.height;
          }
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;

          return RawScrollbar(
            thumbColor: Colors.white,
            radius: const Radius.circular(3),
            trackColor: Colors.orangeAccent,
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputTextLabelName(
                      keyboardSettingController: keyboardSettingController,
                      keySettingsCrl: keySettingsCrl),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 16, right: 16),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () {
                                keySettingsCrl.openIconsMenu(context);
                              },
                              child: Container(
                                width: (Platform.isAndroid || Platform.isIOS)
                                    ? smallestReftDistance * .35
                                    : smallestReftDistance * .20,
                                height: (Platform.isAndroid || Platform.isIOS)
                                    ? smallestReftDistance * .35
                                    : smallestReftDistance * .20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        color: Colors.transparent, width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blueAccent.withOpacity(.1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: IconBtn(
                                      isDarkMode:
                                          keyboardSettingController.darkMode,
                                      isNotPressed: false,
                                      size: keyboardSettingController.sizeIcon,
                                      color: keyboardSettingController
                                          .currentBtnProperty!.color,
                                      iconName: keyboardSettingController
                                          .currentBtnProperty!.iconName,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            width: smallestReftDistance * .50,
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: StandardButton(
                                    text: "Change icon",
                                    functionOnPress: () {
                                      keySettingsCrl.openIconsMenu(context);
                                    },
                                    backgroundColor:
                                        keyboardSettingController.darkMode
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 16, right: 16),
                                  child: StandardButton(
                                    text: "Change color",
                                    functionOnPress: () {
                                      keySettingsCrl.colorPickerDialog(context);
                                    },
                                    backgroundColor:
                                        keyboardSettingController.darkMode
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, left: 16),
                    child: (keySettingsCrl.currentCommand != null)
                        ? Column(
                            children: [
                              const Text(
                                "Command Assigned",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "${keySettingsCrl.currentCommand!.type.label}: ",
                                      style: const TextStyle(
                                          color: Colors.blueAccent),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      keySettingsCrl
                                          .currentCommand!.functionLabel,
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: ChangeNotifierProvider(
                        create: (context) => GridController(
                            keyboardSettingController.currentBtnProperty!,
                            mainController,
                            keyboardSettingController,
                            gridSelectMode: true,
                            widthTabContainer: width - 42,
                            currentCommandGroupName:
                                Constants.firstGroupCommandName),
                        builder: (context, child) {
                          GridController gridController =
                              context.watch<GridController>();

                          return TabCommandGroup(
                            gridController: gridController,
                            keyboardSettingController:
                                keyboardSettingController,
                            mainController: mainController,
                            width: width,
                            height: height,
                            widgetFooter: GridFooterKeySettings(
                              gridController: gridController,
                              keyboardSettingController:
                                  keyboardSettingController,
                              keySettingsCtrl: keySettingsCrl,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
