import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyboardSettingController extends ChangeNotifier {
  String keyBoardName;
  TextEditingController ctrlVisibleAmountBtn = TextEditingController();
  TextEditingController ctrlAddress = TextEditingController();

  int visibleAmountBtn =3;
  late Size sizeIcon;
  late String prefix;
  String address = "";
  late String routeAddress;
  late String currentSettingName;
  bool showExceptions = false;
  bool showResponses = false;
  late bool darkMode;
  late bool osDarkMode;
  late SharedPreferences preferencesInstance;
  final BuildContext buildContext;
  double slideValue = 10;

  KeyboardSettingController(this.keyBoardName, this.buildContext) {
    var brightness = MediaQuery.of(buildContext).platformBrightness;
    osDarkMode = brightness == Brightness.dark;
    darkMode = osDarkMode;
    
    SharedPreferences.getInstance().then((instance) {
      preferencesInstance = instance;
      loadConfig(keyBoardName);
    });
  }

    void saveConfig() async {
    preferencesInstance.setString('currentSettingName', currentSettingName);
    preferencesInstance.setInt(
        '$currentSettingName visibleAmountBtn', visibleAmountBtn);
    preferencesInstance.setDouble(
        '$currentSettingName size.width', sizeIcon.width);
    preferencesInstance.setDouble(
        '$currentSettingName size.height', sizeIcon.height);
    preferencesInstance.setString('$currentSettingName address', address);
    preferencesInstance.setString(
        '$currentSettingName routeAddress', routeAddress);
    preferencesInstance.setString('$currentSettingName prefix', prefix);
    preferencesInstance.setBool(
        '$currentSettingName showExceptions', showExceptions);
    preferencesInstance.setBool(
        '$currentSettingName showResponses', showResponses);
    preferencesInstance.setBool('$currentSettingName darkMode', darkMode);

    notifyListeners();
  }

    loadConfig(String? settingName) {
    if (settingName != null) {
      currentSettingName = settingName;
    } else {
      currentSettingName =
          preferencesInstance.getString('currentSettingName') ?? "default";
    }

    visibleAmountBtn =
        preferencesInstance.getInt('$currentSettingName visibleAmountBtn') ?? 6;
    sizeIcon = Size(
        preferencesInstance.getDouble('$currentSettingName size.width') ?? 40,
        preferencesInstance.getDouble('$currentSettingName size.height') ?? 40);
    address =
        preferencesInstance.getString('$currentSettingName address') ?? "";
    routeAddress =
        preferencesInstance.getString('$currentSettingName routeAddress') ?? "";
    prefix = preferencesInstance.getString('$currentSettingName prefix') ??
        'http://';
    showExceptions =
        preferencesInstance.getBool('$currentSettingName showExceptions') ??
            false;
    showResponses =
        preferencesInstance.getBool('$currentSettingName showResponses') ??
            false;
    darkMode = preferencesInstance.getBool('$currentSettingName darkMode') ??
        osDarkMode;

    setTextInputAddress();
    notifyListeners();
  }




  void setTextInputAddress() {
    ctrlAddress.text = address;
  }

  void saveAddress(String prefix) {
    updateAddressServer(prefix);
    preferencesInstance.setString('$currentSettingName address', address);
    preferencesInstance.setString('$currentSettingName prefix', prefix);
    preferencesInstance.setString(
        '$currentSettingName routeAddress', routeAddress);

    notifyListeners();
  }

  void updateShowExceptions(bool newValue) {
    showExceptions = newValue;
    preferencesInstance.setBool(
        '$currentSettingName showExceptions', showExceptions);

    notifyListeners();
  }

  void updateShowResponses(bool newValue) {
    showResponses = newValue;
    preferencesInstance.setBool(
        '$currentSettingName showResponses', showResponses);

    notifyListeners();
  }

  void updateThemeMode(bool newValue) {
    darkMode = newValue;
    preferencesInstance.setBool('$currentSettingName darkMode', newValue);
    notifyListeners();
  }



  void updateVisibleAmountBtn() {
    visibleAmountBtn = int.parse(ctrlVisibleAmountBtn.text);
    preferencesInstance.setInt(
        '$currentSettingName visibleAmountBtn', visibleAmountBtn);
  }

  void updateSizeIcon(double size) {
    preferencesInstance.setDouble('$currentSettingName size.width', size);
    preferencesInstance.setDouble('$currentSettingName size.height', size);
    sizeIcon = Size(size, size);
  }

  void updateButtonsVisible(int number){
    visibleAmountBtn = number;
      preferencesInstance.setInt(
        '$currentSettingName visibleAmountBtn', visibleAmountBtn);
  }
  
  void updateAddressServer(String newPrefix) {
    prefix = newPrefix;
    address = ctrlAddress.text;
    routeAddress = "$prefix$address";
  }
}
