import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/common/services/ws_connection.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';

import 'session_debug_controller.dart';

class KeyboardSettingController extends ChangeNotifier
    with WsConnection, SessionDebug {
  TextEditingController ctrlVisibleAmountBtn = TextEditingController();
  TextEditingController ctrlAddress = TextEditingController();
  final MainController mainController;
  int visibleAmountBtn = 3;
  double spaceDebugSessionSelector = 55;
  Size sizeIcon = const Size(40, 40);
  String prefix = 'http://';
  String address = "";
  String routeAddress = "";
  String currentSettingName = "default";
  bool showExceptions = true;
  bool showResponses = true;
  bool lockKeyboard = false;
  bool darkMode = true;
  bool osDarkMode = false;
  BtnProperty? currentBtnProperty;
  late SharedPreferences preferencesInstance;
  final BuildContext buildContext;
  double slideValue = 10;

  KeyboardSettingController(
    this.mainController,
    this.buildContext,
  ) {
    var brightness = MediaQuery.of(buildContext).platformBrightness;
    osDarkMode = brightness == Brightness.dark;
    darkMode = osDarkMode;

    SharedPreferences.getInstance().then((instance) {
      preferencesInstance = instance;
      loadConfig(mainController.currentKeyBoard.keyBoardName);
      tryWebsocketConnection();
    });
  }

  void tryWebsocketConnection() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (address != "" && routeAddress.contains("ws")) {
      connectToWebsocket(routeAddress, notifyListeners);
      startOnMessageWs();
      notifyListeners();
    }
  }

  void startOnMessageWs() {
    onMessageWebsocket(
        functionCallback: getModelSessionDebug,
        notifyListeners: notifyListeners);
    notifyListeners();
  }

  void stopWebsocketConnection() {
    disconnectWebsocket();
    clearListSession();
    notifyListeners();
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
    preferencesInstance.setBool(
        '$currentSettingName lockKeyboard', lockKeyboard);
  }

  loadConfig(String? settingName) {
    if (settingName != null) {
      currentSettingName = settingName;
    } else {
      currentSettingName =
          preferencesInstance.getString('currentSettingName') ??
              currentSettingName;
    }

    if (preferencesInstance.getString('$currentSettingName prefix') == null) {
      saveConfig();
    }
    prefix =
        preferencesInstance.getString('$currentSettingName prefix') ?? prefix;

    visibleAmountBtn =
        preferencesInstance.getInt('$currentSettingName visibleAmountBtn') ??
            visibleAmountBtn;
    sizeIcon = Size(
        preferencesInstance.getDouble('$currentSettingName size.width') ??
            sizeIcon.width,
        preferencesInstance.getDouble('$currentSettingName size.height') ??
            sizeIcon.height);
    address =
        preferencesInstance.getString('$currentSettingName address') ?? address;
    routeAddress =
        preferencesInstance.getString('$currentSettingName routeAddress') ??
            routeAddress;

    showExceptions =
        preferencesInstance.getBool('$currentSettingName showExceptions') ??
            showResponses;
    showResponses =
        preferencesInstance.getBool('$currentSettingName showResponses') ??
            showResponses;
    darkMode = preferencesInstance.getBool('$currentSettingName darkMode') ??
        osDarkMode;
    lockKeyboard =
        preferencesInstance.getBool('$currentSettingName lockKeyboard') ??
            lockKeyboard;

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

    // notifyListeners();
  }

  void updateShowExceptions(bool newValue) {
    FocusManager.instance.primaryFocus?.unfocus();

    showExceptions = newValue;
    preferencesInstance.setBool(
        '$currentSettingName showExceptions', showExceptions);

    notifyListeners();
  }

  void updateShowResponses(bool newValue) {
    FocusManager.instance.primaryFocus?.unfocus();

    showResponses = newValue;
    preferencesInstance.setBool(
        '$currentSettingName showResponses', showResponses);
    notifyListeners();
  }

  void updateThemeMode(bool newValue) {
    FocusManager.instance.primaryFocus?.unfocus();

    darkMode = newValue;
    preferencesInstance.setBool('$currentSettingName darkMode', newValue);
    notifyListeners();
  }

  // void updateVisibleAmountBtn() {
  //     FocusManager.instance.primaryFocus?.unfocus();

  //   visibleAmountBtn = int.parse(ctrlVisibleAmountBtn.text);
  //   preferencesInstance.setInt(
  //       '$currentSettingName visibleAmountBtn', visibleAmountBtn);
  // }

  void updateSizeIcon(double size) {
    FocusManager.instance.primaryFocus?.unfocus();
    preferencesInstance.setDouble('$currentSettingName size.width', size);
    preferencesInstance.setDouble('$currentSettingName size.height', size);
    sizeIcon = Size(size, size);
    notifyListeners();
  }

  void updateButtonsVisible(int number) {
    FocusManager.instance.primaryFocus?.unfocus();
    visibleAmountBtn = number;
    preferencesInstance.setInt(
        '$currentSettingName visibleAmountBtn', visibleAmountBtn);
  }

  void updateAddressServer(String newPrefix) {
    prefix = newPrefix;
    address = ctrlAddress.text;
    routeAddress = "$prefix$address";
  }

  void updateLockKeyboard(bool isBlocked) {
    lockKeyboard = isBlocked;
    preferencesInstance.setBool(
        '$currentSettingName lockKeyboard', lockKeyboard);
    notifyListeners();
  }

  void setLastPressed(index) {
    for (var i = 0; i < mainController.listBtnProperties.length; i++) {
      mainController.listBtnProperties[i].isLastPressed = false;
      mainController.listBtnProperties[i].save();
    }
    mainController.listBtnProperties[index].isLastPressed = true;
    mainController.listBtnProperties[index].save();
    notifyListeners();
  }

  void updateCounter(index) {
    mainController.listBtnProperties[index].increaseCounter();
    mainController.listBtnProperties[index].save();
    notifyListeners();
  }

  void resetCounter(index) {
    mainController.listBtnProperties[index].clearCounter();
    mainController.listBtnProperties[index].save();
    notifyListeners();
  }

  void resetAllCounters() {
    for (var i = 0; i < mainController.listBtnProperties.length; i++) {
      mainController.listBtnProperties[i].clearCounter();
      mainController.listBtnProperties[i].save();
    }
    notifyListeners();
  }
}
