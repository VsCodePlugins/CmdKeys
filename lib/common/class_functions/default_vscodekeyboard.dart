import 'package:flutter/material.dart';
import 'package:vsckeyboard/common/model/command_model.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/keyboard_buttons.dart';

class VsCodeKeyBoard extends KeyBoardButtons {
  VsCodeKeyBoard() : super("VsCode Keyboard", listBtnProperties: []);

  Future<List<BtnProperty>> createDebugVsCodeKeyboard(
      List<ModelCommand> listCmd) async {
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 0,
        iconName: "bug",
        functionName:
            listCmd.firstWhere((element) => element.name == "startDebug").name,
        functionLabel: listCmd
            .firstWhere((element) => element.name == "startDebug")
            .functionLabel,
        idCommand:
            listCmd.firstWhere((element) => element.name == "startDebug").id,
        mapCommand: listCmd
            .firstWhere((element) => element.name == "startDebug")
            .mapCommand,
        color: Colors.green));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 1,
        iconName: "play-pause",
        functionName:
            listCmd.firstWhere((element) => element.name == "continue").name,
        functionLabel: listCmd
            .firstWhere((element) => element.name == "continue")
            .functionLabel,
        idCommand:
            listCmd.firstWhere((element) => element.name == "continue").id,
        mapCommand:
            listCmd.firstWhere((element) => element.name == "continue").mapCommand,
        color: Colors.blueAccent));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 2,
        iconName: "debugStepOver",
        functionName: listCmd
            .firstWhere((element) => element.name == "debugStepOver")
            .name,
        functionLabel: listCmd
            .firstWhere((element) => element.name == "debugStepOver")
            .functionLabel,
        idCommand:
            listCmd.firstWhere((element) => element.name == "debugStepOver").id,
        mapCommand: listCmd
            .firstWhere((element) => element.name == "debugStepOver")
            .mapCommand,
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 3,
        iconName: "debugStepInto",
        functionName: listCmd
            .firstWhere((element) => element.name == "debugStepInto")
            .name,
        functionLabel: listCmd
            .firstWhere((element) => element.name == "debugStepInto")
            .functionLabel,
        idCommand:
            listCmd.firstWhere((element) => element.name == "debugStepInto").id,
        mapCommand: listCmd
            .firstWhere((element) => element.name == "debugStepInto")
            .mapCommand,
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 4,
        iconName: "debugStepOut",
        functionName: listCmd
            .firstWhere((element) => element.name == "debugStepOut")
            .name,
        functionLabel: listCmd
            .firstWhere((element) => element.name == "debugStepOut")
            .functionLabel,
        idCommand:
            listCmd.firstWhere((element) => element.name == "debugStepOut").id,
        mapCommand: listCmd
            .firstWhere((element) => element.name == "debugStepOut")
            .mapCommand,
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 5,
        iconName: "restart",
        functionName:
            listCmd.firstWhere((element) => element.name == "restart").name,
        functionLabel: listCmd
            .firstWhere((element) => element.name == "restart")
            .functionLabel,
        mapCommand:
            listCmd.firstWhere((element) => element.name == "restart").mapCommand,
        idCommand:
            listCmd.firstWhere((element) => element.name == "restart").id,
        color: Colors.green));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 6,
        iconName: "stop",
        functionName:
            listCmd.firstWhere((element) => element.name == "stop").name,
        functionLabel: listCmd
            .firstWhere((element) => element.name == "stop")
            .functionLabel,
        mapCommand:
            listCmd.firstWhere((element) => element.name == "stop").mapCommand,
         idCommand:
            listCmd.firstWhere((element) => element.name == "stop").id,
        color: Colors.red));

    return listBtnProperties;
  }
}
