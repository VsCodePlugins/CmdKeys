import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vsckeyboard/common/class_functions/dropdown_controllers.dart';
import 'package:vsckeyboard/common/class_functions/ip_address_input.dart';
import 'package:vsckeyboard/common/widgets/button_ws.dart';
import 'package:vsckeyboard/common/widgets/number_picker.dart';
import 'package:vsckeyboard/common/widgets/simple_dropdown.dart';
import 'package:vsckeyboard/common/widgets/slider_setting.dart';
import 'package:vsckeyboard/common/widgets/standard_button.dart';
import 'package:vsckeyboard/common/widgets/switch_setting.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';

class KeyboardSettings extends StatefulWidget {
  final String keyBoardName;
  final void Function() notify;

  const KeyboardSettings({
    super.key,
    required this.keyBoardName,
    required this.notify,
  });

  @override
  State<KeyboardSettings> createState() => _KeyboardSettingsState();
}

class _KeyboardSettingsState extends State<KeyboardSettings> {
  String address = '';
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DropDownPrefixCtrl>(
            create: (_) => DropDownPrefixCtrl(
              focusNode,
              "TYPE",
              ['ws://', 'wss://', 'http://', 'https://'],
            ),
          ),
          ChangeNotifierProvider<DropDownSuffixCtrl>(
            create: (_) => DropDownSuffixCtrl(
              focusNode,
              "CONNECT_TO",
              ['IP:PORT', 'URL'],
            ),
          ),
        ],
        builder: (context, child) {
          DropDownSuffixCtrl dropdownCtrlS =
              Provider.of<DropDownSuffixCtrl>(context);
          DropDownPrefixCtrl dropdownCtrlP =
              Provider.of<DropDownPrefixCtrl>(context);
          KeyboardSettingController settingController =
              Provider.of<KeyboardSettingController>(context, listen: false);

          MainController mainController = Provider.of<MainController>(context);

          if (dropdownCtrlS.changeValue) {
            settingController.ctrlAddress.clear();
            dropdownCtrlS.changeValue = false;
            settingController.disconnectWebsocket();
          }
          if (dropdownCtrlP.changeValue) {
            settingController.saveAddress(dropdownCtrlP.selectedValue);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Center(
                //   child: Padding(
                //       padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                //       child: Text(
                //         widget.keyBoardName,
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             color: settingController.darkMode
                //                 ? Colors.white
                //                 : Colors.black,
                //             fontSize: 24),
                //       )),
                // ),
                Theme(
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
                          color: settingController.darkMode
                              ? Colors.white
                              : Colors.black),
                      prefixStyle: TextStyle(
                          color: settingController.darkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                      hintStyle: TextStyle(
                          color: settingController.darkMode
                              ? const Color.fromARGB(255, 66, 66, 66)
                              : const Color.fromARGB(255, 201, 201, 201)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 85,
                      child: TextField(
                        onChanged: (value) {
                          settingController
                              .saveAddress(dropdownCtrlP.selectedValue);
                          settingController.stopWebsocketConnection();
                          widget.notify();
                        },
                        key: const Key('host_text_field'),
                        controller: settingController.ctrlAddress,
                        focusNode: focusNode,
                        autofocus: false,
                        inputFormatters: [
                          if (dropdownCtrlS.selectedValue == 'IP')
                            InputValid.ipAddressInputFilter(),
                          if (dropdownCtrlS.selectedValue == 'IP:PORT')
                            InputValid.ipAddressInputFilterWithPort(),
                          if (dropdownCtrlS.selectedValue.contains("IP"))
                            IpAddressInputFormatter(),
                          if (dropdownCtrlS.selectedValue.contains("IP"))
                            LengthLimitingTextInputFormatter(21),
                          if (dropdownCtrlS.selectedValue == 'URL')
                            InputValid.urlInputFilter(),
                        ],
                        minLines: 1,
                        maxLines: 3,
                        style: TextStyle(
                            color: settingController.darkMode
                                ? Colors.white
                                : Colors.black), //<-- HERE
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.blue.withOpacity(.1),
                            hintText: (dropdownCtrlS.selectedValue == 'IP')
                                ? '192.168.1.1'
                                : (dropdownCtrlS.selectedValue == 'IP:PORT')
                                    ? '192.168.1.1:3333'
                                    : 'www.host.com',
                            labelText: 'HOST',
                            prefix: DropDownPrefix(
                              isDarkMode: settingController.darkMode,
                            ),
                            suffix: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropDownSuffix(
                                isDarkMode: settingController.darkMode,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                dropdownCtrlP.selectedValue.contains("ws") &&
                        settingController.address != ""
                    ? Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16.0, left: 16, right: 16),
                        child: WsConnectButton(
                            settingController: settingController),
                      )
                    : const SizedBox.shrink(),

                SliderSetting(
                  isDarkMode: settingController.darkMode,
                  size: settingController.sizeIcon.width,
                  onChange: settingController.updateSizeIcon,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: StandardButton(
                    functionOnPress: (){
                        if (Platform.isAndroid || Platform.isIOS) {
                            Vibration.vibrate(duration: 200);
                          }
                          settingController.resetAllCounters();
                    },
                      childWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              MdiIcons.counter,
                              color: Colors.blue,
                            ),
                          ),
                          const Text(
                            "Reset counters",
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                      text: null,
                      backgroundColor: Colors.blue.withOpacity(.2)),
                ),
                SwitchSetting(
                  state: settingController.darkMode,
                  functionOnChange: settingController.updateThemeMode,
                  isDarkMode: settingController.darkMode,
                  label: "Dark Mode",
                  notify: widget.notify,
                ),
                SwitchSetting(
                  state: settingController.showExceptions,
                  functionOnChange: settingController.updateShowExceptions,
                  isDarkMode: settingController.darkMode,
                  label: "Show Exceptions",
                  notify: widget.notify,
                ),
                SwitchSetting(
                  state: settingController.showResponses,
                  functionOnChange: settingController.updateShowResponses,
                  isDarkMode: settingController.darkMode,
                  label: "Show Responses",
                  notify: widget.notify,
                ),
                SwitchSetting(
                  state: settingController.listMode,
                  functionOnChange: settingController.updateListMode,
                  isDarkMode: settingController.darkMode,
                  label: "List Mode",
                  notify: widget.notify,
                ),

                if (settingController.listMode)
                  PickerNumber(
                    key: const ValueKey("listMode"),
                    text: 'Buttons visible on screen',
                    value: settingController.visibleAmountBtn,
                    minValue: 1,
                    maxValue:
                        mainController.currentKeyBoard.listBtnProperties.length,
                    onChangedCallback: settingController.updateButtonsVisible,
                    keyboardSettingController: settingController,
                  ),

                if (!settingController.listMode)
                  PickerNumber(
                    key: const ValueKey("gridMode"),
                    text: 'Grid Set Number',
                    value: settingController.gridColumnNumber,
                    minValue: 2,
                    maxValue: (Platform.isAndroid || Platform.isIOS)
                        ? 3
                        : mainController
                            .currentKeyBoard.listBtnProperties.length,
                    onChangedCallback:
                        settingController.updateGridColumnCounter,
                    keyboardSettingController: settingController,
                  ),
              ],
            ),
          );
        });
  }
}
