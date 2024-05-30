import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/common/model/command_types.dart';
import 'package:vsckeyboard/common/model/command_model.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import '../model/command_group_model.dart';
import 'default_command_groups.dart';

mixin CommandsController {
  String keyBaseCommandGroup = "keyBaseCommandGroup";
  List<ModelCommandGroup> commandGroups = [];
  List<ModelCommand>? listModelCommand;
  ModelCommandGroup? currentCommandGroup;

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
      ModelCommand? modelCmd = await ModelCommand.loadCommand(
          key: key, sharedPreferences: sharedPreferences);
      if (modelCmd == null) {
        return null;
      }
      commands.add(modelCmd);
    }
    commands.sort((a, b) => a.index.compareTo(b.index));
    return commands;
  }

  Future<void> runCommand({
    required dynamic command,
    required MainController mainController,
    required KeyboardSettingController keyboardSettingCtrl,
  }) async {
    Map<String, dynamic> decodeCommand = {};
    try {
      decodeCommand = json.decode(command);
    } on Exception {
      throw Exception(
          "Error: Invalid format detected. Please ensure the command is in valid JSON format and try again");
    }
    for (String key in decodeCommand.keys) {
      if (decodeCommand[key] == "") {
        throw Exception(
            "Error: Invalid format detected. Please provide a valid value for $key");
      }
    }
    await mainController.sentCommand(decodeCommand, keyboardSettingCtrl);
  }
}
