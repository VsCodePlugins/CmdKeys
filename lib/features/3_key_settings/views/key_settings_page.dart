import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/common/widgets/icon_command.dart';
import 'package:vsckeyboard/common/widgets/standar_button.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'package:vsckeyboard/features/3_key_settings/controllers/keysettings_controller.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

IconData getIconDataWithName(String nameIcon) {
  return MdiIcons.fromString(nameIcon) ?? Icons.close;
}

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

        Future<IconData?> openIconsMenu() async {
          FocusManager.instance.primaryFocus?.previousFocus();
          FocusManager.instance.primaryFocus?.requestFocus();

          List<String> listNameIcons = MdiIcons.getNames();

          Map<String, IconData> mapIconsName = {
            for (var nameIcon in listNameIcons)
              nameIcon: getIconDataWithName(nameIcon)
          };
          Map<int, String> mapCodePointIconsName = {
            for (var nameIcon in listNameIcons)
              getIconDataWithName(nameIcon).codePoint: nameIcon
          };

          IconData? iconSelected = await showIconPicker(context,
              adaptiveDialog: true, customIconPack: mapIconsName);
          if (iconSelected != null) {
            String? nameIcon = mapCodePointIconsName[iconSelected.codePoint];
            keyboardSettingController.currentBtnProperty!.iconName = nameIcon!;
            
          }
          return iconSelected;
        }

        return OrientationBuilder(builder: (context, orientation) {
          late double smallestReftDistance;
          if (orientation == Orientation.portrait) {
            smallestReftDistance = MediaQuery.of(context).size.width;
          } else {
            smallestReftDistance = MediaQuery.of(context).size.height;
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: smallestReftDistance * .40,
                        height: smallestReftDistance * .40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: IconBtn(
                              isDarkMode: keyboardSettingController.darkMode,
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
                    SizedBox(
                      width: smallestReftDistance * .50,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: StanderButton(
                              text: "Change icon",
                              functionOnPress: openIconsMenu,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, right: 16),
                            child: StanderButton(
                              text: "Change color",
                              functionOnPress: openIconsMenu,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              InputTextLabelName(
                  keyboardSettingController: keyboardSettingController,
                  keySettingsCrl: keySettingsCrl),
              Container(),
            ],
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
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueAccent,
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
              color: Colors.white30,
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
                keyboardSettingController.currentBtnProperty!.functionLabel =
                    value;
                keyboardSettingController.currentBtnProperty!.save();
              },
              controller: keySettingsCrl.textControllerNameBtn,
              key: const Key('name_btn'),
              style: TextStyle(
                  color: keyboardSettingController.darkMode
                      ? Colors.white
                      : Colors.black), //<-- HERE
              decoration: InputDecoration(
                hintText: "Name of Button",
                labelText:
                    "Button: ${keyboardSettingController.currentBtnProperty!.functionLabel}",
              )),
        ),
      ),
    );
  }
}
