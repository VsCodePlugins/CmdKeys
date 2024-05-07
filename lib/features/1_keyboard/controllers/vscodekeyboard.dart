import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/command.dart';

class VsCodeKeyBoard extends KeyBoardCommand {
  VsCodeKeyBoard() : super("VsCode", listBtnProperties: []) {
    listBtnProperties = createDebugVsCodeKeyboard();
  }
  static const JsonCodec json = JsonCodec();

  List<BtnProperty> createDebugVsCodeKeyboard() {
    String keyValue = "command";
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 0,
        iconName: "bug",
        functionName: "continue",
        functionLabel: "Continue",
        functionCommand:   {keyValue:"continue"},
        color: Colors.green));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 1,
        iconName: "debugStepOver",
        functionName: "debugStepOver",
        functionLabel: "Step Over",
        functionCommand: {keyValue:"debugStepOver"},
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 2,
        iconName: "debugStepInto",
        functionName: "debugStepInto",
        functionLabel: "Step Into",
        functionCommand:  {keyValue:"debugStepInto"},
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 3,
        iconName: "debugStepOut",
        functionName: "debugStepOut",
        functionLabel: "Step Out",
        functionCommand:{keyValue:"debugStepOut"},
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 4,
        iconName: "lightningBolt",
        functionName: "hotReload",
        functionLabel: "Hot Reload",
        functionCommand:   {keyValue:"hotReload"},
        color: Colors.orange));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 5,
        iconName: "restart",
        functionName: "restart",
        functionLabel: "Restart",
        functionCommand:  {keyValue:"restart"},
        color: Colors.green));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 6,
        iconName: "stop",
        functionName: "stop",
        functionLabel: "Stop",
        functionCommand:  {keyValue:"stop"},
        color: Colors.red));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 7,
        iconName: "toolbox",
        functionName: "devTools",
        functionLabel: "Dev Tools",
        functionCommand: {keyValue:"devTools"},
        color: Colors.blue[900]!));

    return listBtnProperties;
  } }