import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vsckeyboard/common/class_functions/command_controller.dart';
import 'package:vsckeyboard/common/constants.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';

class GridController with ChangeNotifier, CommandsController {
  int currentIndex = 0;
  BtnProperty currentBtnProperty;
  StreamController<Map<String, dynamic>> gridStateCtrl =
      StreamController<Map<String, dynamic>>.broadcast();
  late Stream<Map<String, dynamic>> gridStreamState;

  void updateCurrentCommand(int? index) {
    if (index == null) {
      return;
    }
    currentIndex = index;

    gridStateCtrl.sink.add({"currentIndex": currentIndex});
    notifyListeners();
  }

  GridController(
    this.currentBtnProperty,
  ) {
    gridStreamState = gridStateCtrl.stream;

    initColumnsRows(
      stream: gridStreamState,
        currentBtnProperty, Constants.firstGroupCommandName, notifyListeners,
        selectRadio: updateCurrentCommand);
  }

  //  columnCommandsTable = getPlutoColumns(
  //       modelCommandGroup: currentCommandGroup!,
  //       index: currentIndex,
  //       selectRadio: updateCurrentCommand);
}
