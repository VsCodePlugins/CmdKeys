import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/common/class_functions/default_vscodekeyboard.dart';
import 'package:vsckeyboard/common/constants.dart';
import 'package:vsckeyboard/common/model/command_group_model.dart';
import 'package:vsckeyboard/common/model/command_model.dart';
import 'package:vsckeyboard/common/services/http_request.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'keyboard_buttons.dart';

class MainController with ChangeNotifier, HttpRequest {
  KeyBoardButtons currentKeyBoard = VsCodeKeyBoard();
    ScrollController listCommandBtnScroll = ScrollController();
   GlobalKey keyCommandBtnScroll =  GlobalKey();

  Map<String, KeyBoardButtons> mapBtnProperties = {};
  List<BtnProperty> listBtnProperties = [];
  late SharedPreferences preferencesInstance;
  StreamController<Map<String, dynamic>> mainStreamStateCtrl =
      StreamController<Map<String, dynamic>>.broadcast();
  late Stream<Map<String, dynamic>> mainStreamState;
  MainController() {
    mainStreamState = mainStreamStateCtrl.stream;

    Future.sync(() => null).then((_) async {
      preferencesInstance = await SharedPreferences.getInstance();
      bool isSaved = await _isDefaultListSaved();

      if (!isSaved) {
        await currentKeyBoard.getCommandGroups(preferencesInstance);
        listBtnProperties = await _loadListBtnProperties(
            sharedPreferences: preferencesInstance);
        mapBtnProperties[currentKeyBoard.keyBoardName] = currentKeyBoard;
        currentKeyBoard.saveListBtnProperties();
      }
      notifyListeners();
    });
  }
    String generateRandomString(int len) {
    var r = Random();
    String randomString =String.fromCharCodes(List.generate(len, (index)=> r.nextInt(33) + 89));
      return randomString;
    }


  Future<String?> sentCommand(
      Map<String, dynamic> command, KeyboardSettingController keyboardSettingCtrl, String idCommand) async {
    
    command["eventID"] = "event_${idCommand}_${generateRandomString(4)}";
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

  Future<bool> _isDefaultListSaved() async {
    if (listBtnProperties.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<BtnProperty>> _loadListBtnProperties(
      {KeyBoardButtons? keyBoard,
      required SharedPreferences sharedPreferences}) async {
    if (keyBoard == null) {
      VsCodeKeyBoard vsKeyBoardCommand = VsCodeKeyBoard();
      ModelCommandGroup? commandGroup = vsKeyBoardCommand.getModelCommandGroup(
          commandGroupName: Constants.firstGroupCommandName,
          sharedPreferences: sharedPreferences);
      assert(commandGroup != null,
          "Error to get CommandGroup: ${Constants.firstGroupCommandName}");

      List<ModelCommand>? listCmd =
          await vsKeyBoardCommand.getListCommandsByGroupName(
              modelCommandGroup: commandGroup!,
              sharedPreferences: sharedPreferences);
      await vsKeyBoardCommand.createDebugVsCodeKeyboard(listCmd!);
      listBtnProperties = vsKeyBoardCommand.listBtnProperties;
      keyBoard = vsKeyBoardCommand;
    }
    for (var i = 0; i < keyBoard.listBtnProperties.length; i++) {
      BtnProperty btnProperty = await BtnProperty.getBtProperty(
          groupName: keyBoard.keyBoardName, index: i);
      if (btnProperty.functionName != "default") {
        listBtnProperties[i] = btnProperty;
      }
    }
    currentKeyBoard = keyBoard;
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

  updateMainInterface(){
    notifyListeners();
  }
}
