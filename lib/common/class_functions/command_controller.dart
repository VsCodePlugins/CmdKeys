import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/common/model/command_types.dart';
import 'package:vsckeyboard/common/model/command_model.dart';
import '../model/command_group_model.dart';
import 'default_command_groups.dart';

mixin CommandsController {
  String keyBaseCommandGroup = "keyBaseCommandGroup";

  List<ModelCommandGroup> commandGroups = [];


  Future<List<ModelCommandGroup>> getCommandGroups() async {
    if (commandGroups.isNotEmpty) {
      commandGroups.clear();
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Set<String> allKeys = sharedPreferences.getKeys();
    Set<String> keysCommandsGroups =
        allKeys.where((key) => key.contains(keyBaseCommandGroup) && key.contains("_cmd_group_")).toSet();

    if (keysCommandsGroups.isEmpty) {
       commandGroups = await  createDefaultCommandGroups(keyBaseCommandGroup: keyBaseCommandGroup);
      keysCommandsGroups =
          allKeys.where((key) => key.contains(keyBaseCommandGroup) && key.contains("_cmd_group_") ).toSet();
    }

    for (String key in keysCommandsGroups) {
      ModelCommandGroup? commandGroup = ModelCommandGroup.loadCommandGroup(
          key: key, sharedPreferences: sharedPreferences);
          
      if (commandGroup != null) {
        commandGroups.add(commandGroup);
      }
    }
    return commandGroups;
  }

  Future<ModelCommandGroup> createNewGroup(
      {required String commandGroupName,
      required String label,
      String description = "",
      required CommandType onlyType}) async {
    ModelCommandGroup commandsGroup = ModelCommandGroup(
        onlyType: onlyType,
        name: commandGroupName,
        description: description,
        label: label);
    return commandsGroup.saveAs(keyBaseCommandGroup: keyBaseCommandGroup);
  }

  Future<ModelCommandGroup?> _getModelCommandGroup(
      {required String commandGroupName}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Set<String> allKeys = sharedPreferences.getKeys();

    Set<String> keysCommandsGroups =
        allKeys.where((key) => key.contains(keyBaseCommandGroup) && key.contains("_cmd_group_")).toSet();

    for (String key in keysCommandsGroups) {
      ModelCommandGroup? commandGroup = ModelCommandGroup.loadCommandGroup(
          key: key, sharedPreferences: sharedPreferences);
      if (commandGroup == null) {
        continue;
      }
      if (commandGroup.name == commandGroupName) {
        return commandGroup;
      }
    }
    return null;
  }

  Future<List<ModelCommand>?> getListCommandsByGroupName(
      {required String commandGroupName}) async {
    List<ModelCommand> commands = [];
    ModelCommandGroup? modelCommandGroup =
        await _getModelCommandGroup(commandGroupName: commandGroupName);
    if (modelCommandGroup == null) {
      return null;
    }

    String commandGroupID = modelCommandGroup.id;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Set<String> allKeys = sharedPreferences.getKeys();
    Set<String> keyOfListModelCommands =
        allKeys.where((key) => key.contains(commandGroupID) && key.contains("_cmd_model_")).toSet();

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
    return commands;
  }
}
