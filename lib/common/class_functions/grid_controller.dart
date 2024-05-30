import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/common/class_functions/command_controller.dart';
import 'package:vsckeyboard/common/constants.dart';
import 'package:vsckeyboard/common/model/command_group_model.dart';
import 'package:vsckeyboard/common/model/command_model.dart';
import 'package:vsckeyboard/common/model/command_types.dart';
import 'package:vsckeyboard/common/widgets/toast.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

class GridController with ChangeNotifier, CommandsController {
  int currentIndex = 0;
  BtnProperty? currentBtnProperty;
  MainController mainController;
  KeyboardSettingController keyboardSettingCtrl;
  StreamController<Map<String, dynamic>> gridStateCtrl =
      StreamController<Map<String, dynamic>>.broadcast();
  bool gridSelectMode = false;
  bool editMode = false;
  List<PlutoRow> rowCommandsTable = [];
  List<PlutoColumn> columnCommandsTable = [];
  final double widthTabContainer;
  late Stream<Map<String, dynamic>> gridStreamState;
  PlutoGridStateManager ?stateManager;
  Map<String, dynamic> selectedRow = {};

  void updateCurrentIndex(int? index) {
    if (index == null) {
      return;
    }
    selectedRow = {};

    currentIndex = index;

    for (String ptoRow in rowCommandsTable[currentIndex].cells.keys) {
      selectedRow[ptoRow] = rowCommandsTable[currentIndex].cells[ptoRow]!.value;
    }
    try {
      selectedRow["command"] = json.decode(selectedRow["command"]);
      // ignore: empty_catches
    } catch (e) {}
    gridStateCtrl.sink.add({
      "MapRow": selectedRow,
      "currentIndex": currentIndex,
      "currentItem": rowCommandsTable[currentIndex].cells
    });

    notifyListeners();
  }

  void setEditMode(bool isEditMode) {
    editMode = isEditMode;
    gridStateCtrl.sink.add({
      "editMode": isEditMode,
    });
    notifyListeners();
  }

  void selectCommand(PlutoGridOnSelectedEvent event) {
    selectedRow = {};

    for (String ptoRow in event.row!.cells.keys) {
      selectedRow[ptoRow] = event.row!.cells[ptoRow]!.value;
    }
    try {
      selectedRow["command"] = json.decode(selectedRow["command"]);
      // ignore: empty_catches
    } catch (e) {}

    gridStateCtrl.sink.add({
      "MapRow": selectedRow,
    });
  }

  showToast(Widget toast, fToast, context) {
    fToast.init(context);

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  runCmd(int? index, BuildContext context) {
    FToast fToast = FToast();

    runCommand(
            command: rowCommandsTable[index!].cells["command"]!.value,
            mainController: mainController,
            keyboardSettingCtrl: keyboardSettingCtrl)
        .then((onValue) {}, onError: (e) {
      if (mainController.showExceptions()) {
        showToast(
            MessageToast(
              message: e.toString(),
              iconToast: const Icon(
                Icons.error,
                color: Colors.orange,
              ),
              isDarkMode: keyboardSettingCtrl.darkMode,
            ),
            fToast,
            context);
      }
    });
    notifyListeners();
  }

  GridController(
      this.currentBtnProperty, this.mainController, this.keyboardSettingCtrl,
      {this.gridSelectMode = false, required this.widthTabContainer}) {
    gridStreamState = gridStateCtrl.stream;


    initColumnsRows(
            stream: gridStreamState,
            currentBtnProperty,
            Constants.firstGroupCommandName,
            notifyListeners,
            selectRadio: updateCurrentIndex,
            onRunIt: runCmd,
            selectMode: gridSelectMode,
            widthTabContainer: widthTabContainer)
        .then((onValue) {
      currentIndex = (currentBtnProperty != null)
          ? listModelCommand!
              .firstWhere(
                  (element) => element.id == currentBtnProperty!.idCommand)
              .index
          : 0;
    });
  }

  Future<void> initColumnsRows(
    BtnProperty? currentBtnProperty,
    String commandGroupName,
    void Function() notify, {
    required Stream<Map<String, dynamic>> stream,
    required void Function(int?)? selectRadio,
    required void Function(int?, BuildContext context)? onRunIt,
    required bool selectMode,
    required double widthTabContainer,
  }) async {
    Stopwatch stopwatch = Stopwatch()..start();
    SharedPreferences preferencesInstance =
        await SharedPreferences.getInstance();

    await getCommandGroups(preferencesInstance).then((onValue) async {
      commandGroups = onValue;
      //notifyListeners();

      ModelCommandGroup? modelCommandGroup = getModelCommandGroup(
          commandGroupName: commandGroupName,
          sharedPreferences: preferencesInstance);

      if (modelCommandGroup == null) {
        return;
      }

      listModelCommand = await getListCommandsByGroupName(
          modelCommandGroup: modelCommandGroup,
          sharedPreferences: preferencesInstance);

      if (listModelCommand == null) {
        return;
      }

      rowCommandsTable = getPlutoRows(listModelCommand!);

      columnCommandsTable = getPlutoColumns(
        modelCommandGroup: modelCommandGroup,
        selectRadio: selectRadio,
        stream: stream,
        onRunIt: onRunIt,
        index: (currentBtnProperty != null)
            ? listModelCommand!
                .firstWhere(
                    (element) => element.id == currentBtnProperty.idCommand)
                .index
            : 0,
        selectMode: selectMode,
        width: widthTabContainer,
      );
      print('initColumnsRows time elapsed ${stopwatch.elapsed.inMilliseconds}');
      notify();
    });
  }

  List<PlutoColumn> getPlutoColumns({
    required Stream<Map<String, dynamic>> stream,
    required ModelCommandGroup modelCommandGroup,
    required void Function(int?)? selectRadio,
    required void Function(int?, BuildContext context)? onRunIt,
    required int index,
    required bool selectMode,
    required double width,
  }) {
    return modelCommandGroup.onlyType.getColumns(
        onRunIt: onRunIt,
        selectRadio: selectRadio,
        stream: stream,
        currentIndex: index,
        selectMode: selectMode,
        width: width);
  }

  List<PlutoRow> getPlutoRows(List<ModelCommand> listModelCommand) {
    List<PlutoRow> listPlutoRow = [];

    for (ModelCommand modelCommand in listModelCommand) {
      if (modelCommand.type == CommandType.debugVscode) {
        listPlutoRow.add(PlutoRow(cells: {
          'id': PlutoCell(
            value: modelCommand.id,
          ),
          'select_command': PlutoCell(value: modelCommand.index),
          'functionLabel': PlutoCell(value: modelCommand.functionLabel),
          'name': PlutoCell(value: modelCommand.name),
          'command':
              PlutoCell(value: json.encode(modelCommand.mapCommand ?? {})),
          'description': PlutoCell(value: modelCommand.description),
          'run_command': PlutoCell(value: json.encode(modelCommand.mapCommand)),
          'created_by_user': PlutoCell(value: modelCommand.deletable.toString())
        }));
      }
    }
    return listPlutoRow;
  }

  Future<void> addNewDebugRow() async {
    int lengthRowsCommandsTable = rowCommandsTable.length;
    ModelCommand modelCommand = ModelCommand(
        index: lengthRowsCommandsTable,
        type: CommandType.debugVscode,
        name: '',
        functionLabel: '',
        description: '',
        mapCommand: {"debugCommand": ""});
    await modelCommand.saveAs(
        commandGroupID: currentCommandGroup!.id,
        sharedPreferences: keyboardSettingCtrl.preferencesInstance);
    stateManager?.appendRows([
      PlutoRow(cells: {
        'id': PlutoCell(
          value: modelCommand.id,
        ),
        'select_command': PlutoCell(value: modelCommand.index),
        'functionLabel': PlutoCell(value: modelCommand.functionLabel),
        'name': PlutoCell(value: modelCommand.name),
        'command': PlutoCell(value: json.encode(modelCommand.mapCommand ?? {})),
        'description': PlutoCell(value: modelCommand.description),
        'run_command': PlutoCell(value: json.encode(modelCommand.mapCommand)),
        'created_by_user': PlutoCell(value: true.toString())
      })
    ]);
    notifyListeners();
  }

  Future<void> removeDebugRow() async {
    int currentIndex = stateManager!.currentRowIdx!;
    stateManager!.removeRows([rowCommandsTable[currentIndex]]);
    ModelCommand.delete(
        sharedPreferences: keyboardSettingCtrl.preferencesInstance,
        id: selectedRow["id"]);
    selectedRow = {};

    gridStateCtrl.sink.add({
      "MapRow": null,
    });
  }

  showCommandsOfGroup(){
    
  }
}
