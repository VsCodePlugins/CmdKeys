import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'command_group.dart';

class ModelCommand {
  final int index;
  final String name;
  final String? command;
  final Map<String, dynamic>? mapCommand;
  final String functionLabel;
  final String description;

  ModelCommand({
    required this.index, 
    required this.name,
    required this.command,
    this.mapCommand,
    required this.functionLabel,
    required this.description,
  }) {
  }

  String toJsonString() {
    return jsonEncode({
      'index': index,
      'name': name,
      'command': command,
      'mapCommand': mapCommand,
      'functionLabel': functionLabel,
      'description': description
    });
  }

  static ModelCommand fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return ModelCommand(
      index: jsonMap['index'],
      name: jsonMap['name'],
      command: jsonMap['command'],
      mapCommand: jsonMap['mapCommand'],
      functionLabel: jsonMap['functionLabel'],
      description: jsonMap['description'],
    );
  }

  Future<void> saveToSharedPreferences(
      {required String commandGroupID}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonString = toJsonString();
    await sharedPreferences.setString("${commandGroupID}_$name", jsonString);
  }

  static Future<ModelCommand?> loadCommand({required String key}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? commandStr = sharedPreferences.getString(key);
    if (commandStr == null) {
      return null;
    }
    ModelCommand model = ModelCommand.fromJson(commandStr);
    return model;
  }
}

mixin Commands {
  String keyGroupBase = "keyGroupBase";

  List<ModelCommand> commands = [];

  Future<List<ModelCommand>?> _getListCommands(
      {String commandGroupName = "default"}) async {
    
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? commandGroupJsonStr = sharedPreferences.getString("${keyGroupBase}_$commandGroupName");

    if (commandGroupJsonStr == null) {
    return  null;
    }

    String commandGroupID = CommandsGroup.fromJson(commandGroupJsonStr).id!;

    Set<String> allKeys = sharedPreferences.getKeys();
    Set<String> keyOfListModelCommands =
        allKeys.where((key) => key.contains(commandGroupID)).toSet();

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

  Future<List<ModelCommand>> obtainListCommands() async {
    await _getListCommands();
    if (commands.isEmpty) {
      _createDefaultList();
      String commandGroupName = "default";
      String commandGroupID = await _createNewGroup(nameGroup: commandGroupName);
      saveListModelCommands(commandGroupID: commandGroupID);
      return commands;
    }
    return commands;
  }

  Future<String> _createNewGroup({required String nameGroup}) async {
    CommandsGroup commandsGroup = CommandsGroup(name: nameGroup);
    await commandsGroup.saveToSharedPreferences(keyGroupBase);
    return commandsGroup.id!;
  }

  void saveListModelCommands({required String commandGroupID}) async {
    for (ModelCommand cmd in commands) {
      await cmd.saveToSharedPreferences(commandGroupID: commandGroupID);
    }
  }

  void _createDefaultList() {
    commands.addAll([
      ModelCommand(
        index: 0,
        name: 'startDebug',
        command: 'startDebug',
        functionLabel: 'Start',
        description:
            'Start new instance of Debugging, Debugging means to run your code step by step, to find the exact point where you made a programming mistake. You then understand what corrections you need to make in your code and debugging tools often allow you to make temporary changes so you can continue running the program. equivalent to F5',
         
      ),
        ModelCommand(
        index: 1,
        name: 'continue',
        command: 'continueDebug',
        functionLabel: 'Continue',
        description:
            '',
      ),
      ModelCommand(
        index: 2,
        name: 'debugStepOver',
        command: 'debugStepOver',
        functionLabel: 'Step Over',
        description:
            'Step Over Debugging is a debugger function that glosses over a line of code, allowing it to execute without stepping into any underlying functions, thereby treating the entire function as a single unit.',
      ),
      ModelCommand(
        index: 3,
        name: 'debugStepInto',
        command: 'debugStepInto',
        functionLabel: 'Step Into',
        description:
            'Step Into command allows you to execute the current activity and move to the next one. If the current activity has child activities, “Step Into” command will move the execution to the first child activity. This command is useful when you want to debug each activity individually and step through the code line by line.',
      ),
      ModelCommand(
        index: 4,
        name: 'debugStepOut',
        command: 'debugStepOut',
        functionLabel: 'Step Out',
        description:
            'Step Out continues running code and suspends execution when the current function returns. The debugger skips through the current function.',
      ),
      ModelCommand(
        index: 5,
          name: 'restart',
          command: 'restartDebug',
          functionLabel: 'Restart',
          description:
              "Restart,If you've made changes to your code while debugging and want to restart debugging with the changes applied, you can use this command to reload the program."),
      ModelCommand(
          index: 6,
          name: 'stop',
          command: 'stopDebug',
          functionLabel: 'Stop',
          description: "Stops the program's execution at the current point.")
    ]);
  }
}
