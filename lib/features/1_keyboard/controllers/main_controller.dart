import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fkeys/common/class_functions/default_vscodekeyboard.dart';
import 'package:fkeys/common/constants.dart';
import 'package:fkeys/common/model/command_group_model.dart';
import 'package:fkeys/common/model/command_model.dart';
import 'package:fkeys/common/services/http_request.dart';
import 'package:fkeys/features/1_keyboard/%20models/button_properties.dart';
import 'package:fkeys/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'keyboard_buttons.dart';

class MainController with ChangeNotifier, HttpRequest {
  KeyBoardButtons currentKeyBoard = VsCodeKeyBoard();
  ScrollController listCommandBtnScroll = ScrollController();
  GlobalKey keyCommandBtnScroll = GlobalKey();

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
    String randomString =
        String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
    return randomString;
  }

  Future<String?> sentCommand(Map<String, dynamic> command,
      KeyboardSettingController keyboardSettingCtrl, String idCommand) async {
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
      {KeyBoardButtons? keyBoard ,
      required SharedPreferences sharedPreferences}) async {

    if (keyBoard == null) {
      VsCodeKeyBoard vsKeyBoardCommand = VsCodeKeyBoard();
      keyBoard = vsKeyBoardCommand;
      
      listBtnProperties = loadBtnPropertyFromStorage(keyBoardName: keyBoard.keyBoardName,
      sharedPreferences: sharedPreferences);
      if (listBtnProperties.isNotEmpty){
        return listBtnProperties;
      }
      
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


  List<BtnProperty> loadBtnPropertyFromStorage( {required String keyBoardName ,
      required SharedPreferences sharedPreferences}){
      Set<String> setLeys = preferencesInstance.getKeys();
  List<BtnProperty>  storageListBtnProperties  = [];
    List<String> listBtnKeys = setLeys
          .where((keyName) =>
              keyName.contains(keyBoardName) && keyName.contains("_btn_"))
          .toList();

      List<String?> listDataStr =
          listBtnKeys.map((e) => preferencesInstance.getString(e)).toList();
    storageListBtnProperties = listDataStr.map((e)=> BtnProperty.fromJson(dataJson: e!)).toList();
    return storageListBtnProperties;
  }
  BtnProperty addNewBtnProperty(
      { required String groupName,
        required Size sizeIcon,
       String iconName = "newBox",
       String functionName = "new_function",
       String functionLabel = "New Function",
      String idCommand = "",
      Color color = Colors.blueAccent}) {
        BtnProperty btnProperty = BtnProperty(
        sizeIcon: sizeIcon,
        index: listBtnProperties.length,
        iconName: iconName,
        functionName: functionName,
        functionLabel: functionLabel,
        idCommand: idCommand,
        color: color);
    btnProperty.saveAs(groupName: groupName);
    listBtnProperties.add(btnProperty);
    notifyListeners();
      return btnProperty;

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

  updateMainInterface() {
    notifyListeners();
  }
}
