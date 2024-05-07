import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/common/class_functions/dropdown_controllers.dart';
import 'package:vsckeyboard/common/class_functions/ip_address_input.dart';
import 'package:vsckeyboard/common/widgets/number_picker.dart';
import 'package:vsckeyboard/common/widgets/simple_dropdown.dart';
import 'package:vsckeyboard/common/widgets/slider_setting.dart';
import 'package:vsckeyboard/common/widgets/switch_setting.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

class CommandsSettings extends StatefulWidget {
  final String keyBoardName;
  const CommandsSettings({
    super.key,
    required this.keyBoardName,
  });

  @override
  State<CommandsSettings> createState() => _CommandsSettingsState();
}

class _CommandsSettingsState extends State<CommandsSettings> {
  FocusNode focusNode = FocusNode();
  String address = '';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DropDownPrefixCtrl>(
            create: (_) => DropDownPrefixCtrl(
              focusNode,
              "TYPE",
              ['http://', 'https://'],
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
              Provider.of<KeyboardSettingController>(context);

          PanelDashBoard panelDashBoard = Provider.of<PanelDashBoard>(context);

          if (dropdownCtrlS.changeValue) {
            settingController.ctrlAddress.clear();
            dropdownCtrlS.changeValue = false;
          }
          if (dropdownCtrlP.changeValue) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                settingController.saveAddress(dropdownCtrlP.selectedValue!));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                      child: Text(
                        widget.keyBoardName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: settingController.darkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: 24),
                      )),
                ),
                Theme(
                  data: ThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
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
                              .saveAddress(dropdownCtrlP.selectedValue!);
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
                          if (dropdownCtrlS.selectedValue!.contains("IP"))
                            IpAddressInputFormatter(),
                          if (dropdownCtrlS.selectedValue!.contains("IP"))
                            LengthLimitingTextInputFormatter(21),
                          if (dropdownCtrlS.selectedValue == 'URL')
                            InputValid.urlInputFilter(),
                        ],
                        style: TextStyle(
                            color: settingController.darkMode
                                ? Colors.white
                                : Colors.black), //<-- HERE
                        decoration: InputDecoration(
                            hintText: (dropdownCtrlS.selectedValue == 'IP')
                                ? '192.168.1.1'
                                : (dropdownCtrlS.selectedValue == 'IP:PORT')
                                    ? '192.168.1.1:3333'
                                    : 'www.myhost.com',
                            labelText: 'HOST',
                            prefix: DropDownPrefix(
                              isDarkMode: settingController.darkMode,
                            ),
                            suffix: DropDownSuffix(
                              isDarkMode: settingController.darkMode,
                            )),
                      ),
                    ),
                  ),
                ),
                PickerNumber(
                  value: settingController.visibleAmountBtn,
                  minValue: 1,
                  maxValue:
                      panelDashBoard.currentKeyBoard.listBtnProperties.length,
                  onChangedCallback: settingController.updateButtonsVisible,
                ),
                SliderSetting(
                  isDarkMode: settingController.darkMode,
                  size: settingController.sizeIcon.width,
                  onChange: settingController.updateSizeIcon,
                ),
                SwitchSetting(
                  state: settingController.darkMode,
                  functionOnChange: settingController.updateThemeMode,
                  isDarkMode: settingController.darkMode,
                  label: "Dark Mode",
                ),
                SwitchSetting(
                    state: settingController.showExceptions,
                    functionOnChange: settingController.updateShowExceptions,
                    isDarkMode: settingController.darkMode,
                    label: "Show Exceptions"),
                SwitchSetting(
                    state: settingController.showResponses,
                    functionOnChange: settingController.updateShowResponses,
                    isDarkMode: settingController.darkMode,
                    label: "Show Responses"),
              ],
            ),
          );
        });
  }
}
