import 'package:flutter/material.dart';
import 'package:vsckeyboard/common/class_functions/grid_controller.dart';
import 'package:vsckeyboard/common/widgets/json_widget.dart';
import 'package:vsckeyboard/common/widgets/standard_button.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'package:vsckeyboard/features/3_key_settings/controllers/key_settings_controller.dart';

class GridFooterKeySettings extends StatelessWidget {
  const GridFooterKeySettings({
    super.key,
    required this.gridController,
    required this.keyboardSettingController,
    required this.keySettingsCtrl,
  });

  final GridController gridController;
  final KeyboardSettingController keyboardSettingController;
  final KeySettingsController keySettingsCtrl;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: gridController.gridStreamState,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (snapshot.data != null && snapshot.data?["MapRow"] != null)
                  StandardButton(
                    text: "Assign Command",
                    functionOnPress: () {
                      keySettingsCtrl.assignCommand(
                          idModelCommand:
                              snapshot.data?['currentItem']['id'].value,
                          commandType: keySettingsCtrl.currentCommand!.type);
                    },
                    height: 20,
                    width: 150,
                    backgroundColor: keyboardSettingController.darkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                StreamBuilder<Map<String, dynamic>>(
                    stream: gridController.gridStreamState,
                    builder: (context, snapshot) {
                      return JsonWidget(dataMap: snapshot.data?["MapRow"]);
                    }),
              ],
            ),
          );
        });
  }
}
