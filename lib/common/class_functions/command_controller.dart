import 'package:pluto_grid/pluto_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/common/model/command_types.dart';
import 'package:vsckeyboard/common/model/command_model.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';
import '../model/command_group_model.dart';
import 'default_command_groups.dart';

mixin CommandsController {
  String keyBaseCommandGroup = "keyBaseCommandGroup";
  List<ModelCommandGroup> commandGroups = [];
  List<PlutoRow> rowCommandsTable = [];
  List<PlutoColumn> columnCommandsTable = [];
  List<ModelCommand>? listModelCommand;
  ModelCommandGroup? currentCommandGroup;

  //ModelCommand currentCommand

  Future<void> initColumnsRows(BtnProperty currentBtnProperty,
      String commandGroupName, void Function() notify,
      {required Stream<Map<String, dynamic>> stream,
      required void Function(int?)? selectRadio}) async {
    Stopwatch stopwatch = Stopwatch()..start();

    SharedPreferences preferencesInstance =
        await SharedPreferences.getInstance();

    getCommandGroups(preferencesInstance).then((onValue) async {
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
        index: listModelCommand!
            .firstWhere((element) => element.id == currentBtnProperty.idCommand)
            .index,
      );

      print('initColumnsRows time elapsed ${stopwatch.elapsed.inMilliseconds}');

      notify();
    });
  }

  List<PlutoColumn> getPlutoColumns(
      {required Stream<Map<String, dynamic>> stream,
      required ModelCommandGroup modelCommandGroup,
      required void Function(int?)? selectRadio,
      required int index}) {
    return modelCommandGroup.onlyType.getColumns(
        onRunIt: (onRunIt) {
          print(onRunIt);
        },
        selectRadio: selectRadio,
        stream: stream,
        currentIndex: index,
        );
  }

  Future<List<ModelCommandGroup>> getCommandGroups(
      SharedPreferences sharedPreferences,
      {bool forceReload = false}) async {
    Stopwatch stopwatch = Stopwatch()..start();
    if (forceReload) {
      commandGroups.clear();
    }

    if (commandGroups.isNotEmpty) {
      return commandGroups;
    }

    Set<String> allKeys = sharedPreferences.getKeys();
    Set<String> keysCommandsGroups = allKeys
        .where((key) =>
            key.contains(keyBaseCommandGroup) && key.contains("_cmd_group_"))
        .toSet();

    if (keysCommandsGroups.isEmpty) {
      commandGroups = await createDefaultCommandGroups(
          keyBaseCommandGroup: keyBaseCommandGroup,
          sharedPreferences: sharedPreferences);
      keysCommandsGroups = allKeys
          .where((key) =>
              key.contains(keyBaseCommandGroup) && key.contains("_cmd_group_"))
          .toSet();
    }

    for (String key in keysCommandsGroups) {
      ModelCommandGroup? commandGroup = ModelCommandGroup.loadCommandGroup(
          key: key, sharedPreferences: sharedPreferences);
      if (commandGroup != null) {
        commandGroups.add(commandGroup);
      }
    }

    stopwatch.stop();
    print('getCommandGroups time elapsed ${stopwatch.elapsed.inMilliseconds}');
    return commandGroups;
  }

  Future<ModelCommandGroup> createNewGroup(
      {required String commandGroupName,
      required String label,
      String description = "",
      required CommandType onlyType,
      required SharedPreferences sharedPreferences}) async {
    ModelCommandGroup commandsGroup = ModelCommandGroup(
        onlyType: onlyType,
        name: commandGroupName,
        description: description,
        label: label);
    return commandsGroup.saveAs(
        keyBaseCommandGroup: keyBaseCommandGroup,
        sharedPreferences: sharedPreferences);
  }

  ModelCommandGroup? getModelCommandGroup(
      {required String commandGroupName,
      required SharedPreferences sharedPreferences}) {
    Set<String> allKeys = sharedPreferences.getKeys();
    if (currentCommandGroup != null) {
      if (currentCommandGroup!.name == commandGroupName) {
        return currentCommandGroup;
      }
    }
    Set<String> keysCommandsGroups = allKeys
        .where((key) =>
            key.contains(keyBaseCommandGroup) && key.contains("_cmd_group_"))
        .toSet();

    for (String key in keysCommandsGroups) {
      ModelCommandGroup? commandGroup = ModelCommandGroup.loadCommandGroup(
          key: key, sharedPreferences: sharedPreferences);
      if (commandGroup == null) {
        continue;
      }
      if (commandGroup.name == commandGroupName) {
        currentCommandGroup = commandGroup;
        return commandGroup;
      }
    }
    return null;
  }

  Future<List<ModelCommand>?> getListCommandsByGroupName(
      {required SharedPreferences sharedPreferences,
      required ModelCommandGroup modelCommandGroup}) async {
    List<ModelCommand> commands = [];

    String commandGroupID = modelCommandGroup.id;
    Set<String> allKeys = sharedPreferences.getKeys();
    Set<String> keyOfListModelCommands = allKeys
        .where((key) =>
            key.contains(commandGroupID) && key.contains("_cmd_model_"))
        .toSet();

    if (keyOfListModelCommands.isEmpty) {
      return null;
    }

    for (String key in keyOfListModelCommands) {
      ModelCommand? modelCmd = await ModelCommand.loadCommand(key: key);
      if (modelCmd == null) {
        return null;
      }
      commands.add(modelCmd);
    }
    commands.sort((a, b) => a.index.compareTo(b.index));
    return commands;
  }

  List<PlutoRow> getPlutoRows(List<ModelCommand> listModelCommand) {
    List<PlutoRow> listPlutoRow = [];

    for (ModelCommand modelCommand in listModelCommand) {
      if (modelCommand.type == CommandType.debugVscode) {
        listPlutoRow.add(PlutoRow(cells: {
          'select_command': PlutoCell(value: modelCommand.index),
          'label': PlutoCell(value: modelCommand.functionLabel),
          'name': PlutoCell(value: modelCommand.name),
          'command': PlutoCell(value: modelCommand.command ?? ""),
          'description': PlutoCell(value: modelCommand.description),
          'run_command': PlutoCell(value: modelCommand.command)
        }));
      }
    }
    return listPlutoRow;
  }
}
