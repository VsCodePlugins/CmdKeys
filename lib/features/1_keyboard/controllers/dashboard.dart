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

  PanelDashBoard() {
    Future.sync(() => null).then((_) async {
      preferencesInstance = await SharedPreferences.getInstance();
      bool isSaved = await isDefaultListSaved();
      if (!isSaved) {
        mapBtnProperties[currentKeyBoard.keyBoardName] = currentKeyBoard;
        currentKeyBoard.saveListBtnProperties();
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


}
