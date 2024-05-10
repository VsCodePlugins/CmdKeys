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
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 0,
        iconName: "bug",
        functionName: "start",
        functionLabel: "Start",
        command:   "startDebug",
        color: Colors.green));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 1,
        iconName: "debugStepOver",
        functionName: "debugStepOver",
        functionLabel: "Step Over",
        command: "stepOverDebug",
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 2,
        iconName: "debugStepInto",
        functionName: "debugStepInto",
        functionLabel: "Step Into",
        command:  "stepIntoDebug",
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 3,
        iconName: "debugStepOut",
        functionName: "debugStepOut",
        functionLabel: "Step Out",
        command:"stepOutDebug",
        color: Colors.blue));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 4,
        iconName: "restart",
        functionName: "restart",
        functionLabel: "Restart",
        command: "restartDebug",
        color: Colors.green));
    listBtnProperties.add(BtnProperty(
        sizeIcon: const Size(50, 50),
        index: 5,
        iconName: "stop",
        functionName: "stop",
        functionLabel: "Stop",
        command: "stopDebug",
        color: Colors.red));
    return listBtnProperties;
  } }