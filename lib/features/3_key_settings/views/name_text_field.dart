import 'package:flutter/material.dart';
import 'package:fkeys/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';
import 'package:fkeys/features/3_key_settings/controllers/key_settings_controller.dart';

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
        padding: const EdgeInsets.only(left: 16.0, right: 16, top:20),
        child: SizedBox(
          height: 60,
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
                fillColor: Colors.blueAccent.withOpacity(.1),
                hintText: "Button name",
                labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                labelText: "Name",
              )),
        ),
      ),
    );
  }
}
