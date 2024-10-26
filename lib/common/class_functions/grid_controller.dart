import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fkeys/common/class_functions/command_controller.dart';
import 'package:fkeys/common/model/command_group_model.dart';
import 'package:fkeys/common/model/command_model.dart';
import 'package:fkeys/common/model/command_types.dart';
import 'package:fkeys/common/model/grid_model.dart';
import 'package:fkeys/common/widgets/toast.dart';
import 'package:fkeys/features/1_keyboard/%20models/button_properties.dart';
import 'package:fkeys/features/1_keyboard/controllers/main_controller.dart';
import 'package:fkeys/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';

class GridController with ChangeNotifier, CommandsController {
  BtnProperty? currentBtnProperty;
  MainController mainController;
  KeyboardSettingController keyboardSettingCtrl;
  StreamController<Map<String, dynamic>> gridStateCtrl =
      StreamController<Map<String, dynamic>>.broadcast();
  late Stream<Map<String, dynamic>> gridStreamState;

  final double widthTabContainer;
  PlutoGridStateManager? stateManager;
  String currentCommandGroupName;
  Map<String, GridModel> mapGridModel = {};
  late GridModel currentGridModel;
  bool gridSelectMode = false;
  int currentIndex = 0;
  late bool editMode = false;
  // Map<String, dynamic> selectedRow = {};
  // List<PlutoRow>currentGridModel.rowCommandsTable = [];
  // List<PlutoColumn> columnCommandsTable = [];

  GridController(
      this.currentBtnProperty, this.mainController, this.keyboardSettingCtrl,
      {this.gridSelectMode = false,
      required this.widthTabContainer,
      required this.currentCommandGroupName}) {
    gridStreamState = gridStateCtrl.stream;
    initTabCommand();
  }

  void initTabCommand({String? commandGroupName}) {
    bool forceReload = false;
    if (commandGroupName != null) {
      if (commandGroupName == currentCommandGroupName) {
        return;
      }
      currentCommandGroupName = commandGroupName;
      forceReload = true;
    }

    currentGridModel =
        buildMapGridModel(currentCommandGroupName)[currentCommandGroupName]!;
    initColumnsRows(
            forceReload: forceReload,
            stream: gridStreamState,
            currentBtnProperty,
            currentCommandGroupName,
            notifyListeners,
            selectRadio: updateCurrentIndex,
            onRunIt: runCmd,
            selectMode: gridSelectMode,
            widthTabContainer: widthTabContainer)
        .then((onValue) {
      currentIndex = (currentBtnProperty != null)
          ? currentListModelCommand!
              .firstWhere(
                  (element) => element.id == currentBtnProperty!.idCommand,
                  orElse: () => currentListModelCommand![0])
              .index
          : 0;
      setEditMode(currentGridModel.editMode, notify: true);
    });
  }

  Map<String, GridModel> buildMapGridModel(String commandGroupName,
      {bool force = false}) {
    //bool editMode = false;
    Map<String, dynamic> selectedRow = {};
    List<PlutoRow> rowCommandsTable = [];
    List<PlutoColumn> columnCommandsTable = [];
    if (mapGridModel[commandGroupName] == null || force == true) {
      GridModel gridModel = GridModel(
          rowCommandsTable: rowCommandsTable,
          columnCommandsTable: columnCommandsTable,
          selectedRow: selectedRow,
          gridSelectMode: gridSelectMode,
          editMode: false,
          currentIndex: currentIndex);

      mapGridModel[commandGroupName] = gridModel;
    }

    return mapGridModel;
  }

  void updateCurrentIndex(int? index) {
    if (index == null) {
      return;
    }
    currentGridModel.selectedRow = {};
    currentIndex = index;
    for (String ptoRow
        in currentGridModel.rowCommandsTable[currentIndex].cells.keys) {
      currentGridModel.selectedRow[ptoRow] =
          currentGridModel.rowCommandsTable[currentIndex].cells[ptoRow]!.value;
    }
    try {
      currentGridModel.selectedRow["mapCommand"] =
          json.decode(currentGridModel.selectedRow["mapCommand"]);
      // ignore: empty_catches
    } catch (e) {}
    gridStateCtrl.sink.add({
      "MapRow": currentGridModel.selectedRow,
      "currentIndex": currentIndex,
      "currentItem": currentGridModel.rowCommandsTable[currentIndex].cells
    });
    notifyListeners();
  }

  void setEditMode(bool isEditMode, {bool notify = true}) {
    currentGridModel.editMode = isEditMode;
    mapGridModel[currentCommandGroupName]!.editMode = isEditMode;
    editMode = isEditMode;
    gridStateCtrl.sink.add({
      "editMode": isEditMode,
    });
    if (notify) {
      notifyListeners();
    }
  }

  void selectCommand(PlutoGridOnSelectedEvent event) {
    currentGridModel.selectedRow = {};

    for (String ptoRow in event.row!.cells.keys) {
      currentGridModel.selectedRow[ptoRow] = event.row!.cells[ptoRow]!.value;
    }
    try {
      currentGridModel.selectedRow["mapCommand"] =
          json.decode(currentGridModel.selectedRow["mapCommand"]);
      // ignore: empty_catches
    } catch (e) {}

    gridStateCtrl.sink.add({
      "MapRow": currentGridModel.selectedRow,
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
      command:
          currentGridModel.rowCommandsTable[index!].cells["mapCommand"]!.value,
      mainController: mainController,
      keyboardSettingCtrl: keyboardSettingCtrl,
      idCommand: currentGridModel.rowCommandsTable[index].cells["id"]!.value,
    ).then((onValue) {}, onError: (e) {
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

  Future<void> initColumnsRows(
    BtnProperty? currentBtnProperty,
    String commandGroupName,
    void Function() notify, {
    required Stream<Map<String, dynamic>> stream,
    required void Function(int?)? selectRadio,
    required void Function(int?, BuildContext context)? onRunIt,
    required bool selectMode,
    required double widthTabContainer,
    required bool forceReload,
  }) async {
    Stopwatch stopwatch = Stopwatch()..start();
    SharedPreferences preferencesInstance =
        await SharedPreferences.getInstance();

    await getCommandGroups(preferencesInstance, forceReload: forceReload)
        .then((onValue) async {
      commandGroups = onValue;
      //notifyListeners();

      ModelCommandGroup? modelCommandGroup = getModelCommandGroup(
          commandGroupName: commandGroupName,
          sharedPreferences: preferencesInstance);

      if (modelCommandGroup == null) {
        return;
      }

      currentListModelCommand = await getListCommandsByGroupName(
          modelCommandGroup: modelCommandGroup,
          sharedPreferences: preferencesInstance);

      if (currentListModelCommand == null) {
        return;
      }

      currentGridModel.rowCommandsTable =
          getPlutoRows(currentListModelCommand!);

      currentGridModel.columnCommandsTable = getPlutoColumns(
        modelCommandGroup: modelCommandGroup,
        selectRadio: selectRadio,
        stream: stream,
        onRunIt: onRunIt,
        index: (currentBtnProperty != null)
            ? currentListModelCommand!
                .firstWhere(
                  (element) => element.id == currentBtnProperty.idCommand,
                  orElse: () => currentListModelCommand![0],
                )
                .index
            : 0,
        selectMode: selectMode,
        width: widthTabContainer,
      );
      print('initColumnsRows time elapsed ${stopwatch.elapsed.inMilliseconds}');
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
      listPlutoRow.add(PlutoRow(cells: {
        'id': PlutoCell(
          value: modelCommand.id,
        ),
        'select_command': PlutoCell(value: modelCommand.index),
        'functionLabel': PlutoCell(value: modelCommand.functionLabel),
        'name': PlutoCell(value: modelCommand.name),
        'mapCommand': PlutoCell(value: json.encode(modelCommand.mapCommand ?? {})),
        'description': PlutoCell(value: modelCommand.description),
        'run_command': PlutoCell(value: json.encode(modelCommand.mapCommand)),
        'created_by_user': PlutoCell(value: modelCommand.deletable.toString())
      }));
    }
    return listPlutoRow;
  }

  Future<void> addNewDebugRow() async {
    int lengthRowsCommandsTable = currentGridModel.rowCommandsTable.length;
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
        'mapCommand': PlutoCell(value: json.encode(modelCommand.mapCommand ?? {})),
        'description': PlutoCell(value: modelCommand.description),
        'run_command': PlutoCell(value: json.encode(modelCommand.mapCommand)),
        'created_by_user': PlutoCell(value: true.toString())
      })
    ]);
    notifyListeners();
  }

  Future<void> removeDebugRow() async {
    int currentIndex = stateManager!.currentRowIdx!;
    stateManager!.removeRows([currentGridModel.rowCommandsTable[currentIndex]]);
    ModelCommand.delete(
        sharedPreferences: keyboardSettingCtrl.preferencesInstance,
        id: currentGridModel.selectedRow["id"]);
    currentGridModel.selectedRow = {};

    gridStateCtrl.sink.add({
      "MapRow": null,
    });
  }
}
