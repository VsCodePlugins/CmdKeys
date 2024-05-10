import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/common/services/http_request.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'command.dart';
import 'vscodekeyboard.dart';

class PanelDashBoard with ChangeNotifier, HttpRequest {
  KeyBoardCommand currentKeyBoard = VsCodeKeyBoard();
  Map<String, KeyBoardCommand> mapBtnProperties = {};
  List<BtnProperty> listBtnProperties = [];
  late SharedPreferences preferencesInstance;
  final PageController pageController = PageController(initialPage: 1);

  PanelDashBoard() {
    Future.sync(() => null).then((_) async {
      preferencesInstance = await SharedPreferences.getInstance();
      bool isSaved = await isDefaultListSaved();
      if (!isSaved) {
        mapBtnProperties[currentKeyBoard.keyBoardName] = currentKeyBoard;
        currentKeyBoard.saveListBtnProperties();
        notifyListeners();
      }
    });
  }

  Future<String?> sentCommand(
      dynamic command, KeyboardSettingController keyboardSettingCtrl) async {
    String routeAddress = preferencesInstance
            .getString('${currentKeyBoard.keyBoardName} routeAddress') ??
        "";

    try {
      if (keyboardSettingCtrl.connectionState is Connected ||
          keyboardSettingCtrl.connectionState is Reconnected) {
        keyboardSettingCtrl.sendCommandWs(command: command);
        return null;
      }
      
      if (keyboardSettingCtrl.routeAddress.contains("ws")) {
        throw Exception(
            "WebSocket Disconnected: Please review and update your connection settings.");
      }
      String message = await sendCommandHttp(command, routeAddress)
          .timeout(const Duration(seconds: 4));
      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isDefaultListSaved() async {
    listBtnProperties = await loadListBtnProperties();
    if (listBtnProperties.isEmpty) {
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  Future<List<BtnProperty>> loadListBtnProperties(
      {KeyBoardCommand? keyBoardCommand}) async {
    keyBoardCommand ??= VsCodeKeyBoard();
    listBtnProperties = keyBoardCommand.listBtnProperties;

    for (var i = 0; i < keyBoardCommand.listBtnProperties.length; i++) {
      BtnProperty btnProperty =
          await BtnProperty.getBtProperty(keyBoardCommand.keyBoardName, i);

      if (btnProperty.functionName != "default") {
        listBtnProperties[i] = btnProperty;
      }
    }
    currentKeyBoard = keyBoardCommand;
    notifyListeners();

    return listBtnProperties;
  }

  bool showExceptions() {
    bool showExceptions = preferencesInstance
            .getBool('${currentKeyBoard.keyBoardName} showExceptions') ??
        false;

    return showExceptions;
  }

  bool showResponses() {
    bool showResponses = preferencesInstance
            .getBool('${currentKeyBoard.keyBoardName} showResponses') ??
        false;

    return showResponses;
  }

  void setLastPressed(index) {
    for (var i = 0; i < listBtnProperties.length; i++) {
      listBtnProperties[i].isLastPressed = false;
      listBtnProperties[i].saveConfig(currentKeyBoard.keyBoardName);
    }
    listBtnProperties[index].isLastPressed = true;
    listBtnProperties[index].saveConfig(currentKeyBoard.keyBoardName);
    notifyListeners();
  }

  void updateCounter(index) {
    listBtnProperties[index].increaseCounter();
    listBtnProperties[index].saveConfig(currentKeyBoard.keyBoardName);
    notifyListeners();
  }

  void resetCounter(index) {
    listBtnProperties[index].clearCounter();
    listBtnProperties[index].saveConfig(currentKeyBoard.keyBoardName);
    notifyListeners();
  }

  void resetAllCounters() {
    for (var i = 0; i < listBtnProperties.length; i++) {
      listBtnProperties[i].clearCounter();
      listBtnProperties[i].saveConfig(currentKeyBoard.keyBoardName);
    }
    notifyListeners();
  }
}
