import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/common/widgets/icon_command.dart';
import 'package:vsckeyboard/common/widgets/standard_button.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'package:vsckeyboard/features/3_key_settings/controllers/key_settings_controller.dart';
import 'package:tab_container/tab_container.dart';

class KeySettings extends StatelessWidget {
  final KeyboardSettingController keyboardSettingController;
  const KeySettings({
    super.key,
    required this.keyboardSettingController,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KeySettingsController(
          currentBtnProperty: keyboardSettingController.currentBtnProperty),
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
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {
                              keySettingsCrl.openIconsMenu(context);
                            },
                            child: Container(
                              width: smallestReftDistance * .40,
                              height: smallestReftDistance * .40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                      color: Colors.transparent, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue.withOpacity(.1)),
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
                                child: StanderButton(
                                  text: "Change icon",
                                  functionOnPress: () {
                                    keySettingsCrl.openIconsMenu(context);
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, right: 16),
                                child: StanderButton(
                                  text: "Change color",
                                  functionOnPress: () {
                                    keySettingsCrl.colorPickerDialog(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                InputTextLabelName(
                    keyboardSettingController: keyboardSettingController,
                    keySettingsCrl: keySettingsCrl),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TabContainer(
                    tabEdge: TabEdge.top,
                    tabsStart: 0.1,
                    tabsEnd: 0.9,
                    tabMaxLength: 200,
                    borderRadius: BorderRadius.circular(20),
                    tabBorderRadius: BorderRadius.circular(12),
                    childPadding: const EdgeInsets.all(16.0),
                    selectedTextStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 15.0,
                    ),
                    unselectedTextStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    colors: [
                      Colors.blue.withOpacity(.1),
                      Colors.blue.withOpacity(.2),
                      Colors.blue.withOpacity(.3),
                    ],
                    tabs: const [
                      Text('Predefine Functions'),
                      Text('Visual Code Commands'),
                      Text('Terminal Commands'),
                    ],
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: smallestReftDistance,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(""),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: smallestReftDistance,
                        child: const Text(""),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: smallestReftDistance,
                        child: const Text(""),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class InputTextLabelName extends StatelessWidget {
  const InputTextLabelName({
    super.key,
    required this.keyboardSettingController,
    required this.keySettingsCrl,
  });

  final KeyboardSettingController keyboardSettingController;
  final KeySettingsController keySettingsCrl;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Colors.blue[300],
          selectionHandleColor: Colors.blueAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              )),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(16),
          )),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
              color: keyboardSettingController.darkMode
                  ? Colors.white
                  : Colors.black,
              fontSize: 20),
          prefixStyle: TextStyle(
              color: keyboardSettingController.darkMode
                  ? Colors.white
                  : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal),
          hintStyle: TextStyle(
              color: keyboardSettingController.darkMode
                  ? const Color.fromARGB(255, 192, 192, 192)
                  : const Color.fromARGB(255, 78, 78, 78)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 85,
          child: TextField(
              focusNode: keySettingsCrl.focusNode,
              onChanged: (value) {
                keySettingsCrl.changeName(value);
              },
              controller: keySettingsCrl.textControllerNameBtn,
              key: const Key('name_btn'),
              style: TextStyle(
                  color: keyboardSettingController.darkMode
                      ? Colors.white
                      : Colors.black), //<-- HERE
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blue.withOpacity(.1),
                hintText: "Name of Button",
                labelText:
                    "Button: ${keyboardSettingController.currentBtnProperty!.functionLabel}",
              )),
        ),
      ),
    );
  }
}
