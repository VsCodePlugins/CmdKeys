import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fkeys/common/services/ws_connection.dart';
import 'package:fkeys/features/1_keyboard/%20models/button_properties.dart';
import 'package:fkeys/features/1_keyboard/controllers/main_controller.dart';

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
  String routeAddress = "localhost:5813";
  String currentSettingName = "default";
  bool showExceptions = true;
  bool showResponses = true;
  bool lockKeyboard = false;
  bool darkMode = true;
  bool osDarkMode = false;
  bool listMode = false;
  int gridColumnNumber = 3;
  BtnProperty? currentBtnProperty;
  late SharedPreferences preferencesInstance;
  final BuildContext buildContext;
  double slideValue = 10;

  StreamController<Map<String, dynamic>> keyboardSettingStateCtrl =
      StreamController<Map<String, dynamic>>.broadcast();
  late Stream<Map<String, dynamic>> keyboardSettingStreamState;

  KeyboardSettingController(
    this.mainController,
    this.buildContext,
  ) {
    keyboardSettingStreamState = keyboardSettingStateCtrl.stream;

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
        functionCallback: proccesIncomingMessage,
        notifyListeners: notifyListeners);
    notifyListeners();
  }

  void proccesIncomingMessage(String message) {
    getModelSessionDebug(message);
    updateStreamIncomingMessage(message);
  }

  void updateStreamIncomingMessage(String data) {
    try {
      Map<String, dynamic> jsonData = json.decode(data);
      keyboardSettingStateCtrl.sink.add({"incomingMessage":jsonData});
    } catch (e) {}
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
     preferencesInstance.setBool(
        '$currentSettingName listMode', listMode);
             preferencesInstance.setInt(
        '$currentSettingName gridColumnNumber', gridColumnNumber);
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
    
    listMode = preferencesInstance.getBool('$currentSettingName listMode') ??
            listMode;
    gridColumnNumber = preferencesInstance.getInt('$currentSettingName gridColumnNumber') ??
            gridColumnNumber;

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
  bool updateListMode(bool value) {
    listMode = value;
    preferencesInstance.setBool('$currentSettingName listMode', listMode);
    notifyListeners();
    return value;
  }
  void updateGridColumnCounter(int value){
    gridColumnNumber = value;
    preferencesInstance.setInt('$currentSettingName gridColumnNumber', gridColumnNumber);
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
