import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'command_types.dart';

class ModelCommand {
  late String id;
  final int index;
  final String name;
  final String? command;
  final Map<String, dynamic>? mapCommand;
  final String functionLabel;
  final String description;
  final CommandType type;

  ModelCommand({
    this.id = "",
    required this.index,
    required this.type,
    required this.name,
    required this.command,
    this.mapCommand,
    required this.functionLabel,
    required this.description,
  }) {
    if (id == "") {
      var uuid = const Uuid();
      id = uuid.v1();
    }
  }

  String toJson() {
    return jsonEncode({
      "id": id,
      'index': index,
      'type': type.name,
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
      id: jsonMap['id'],
      index: jsonMap['index'],
      type: ExtendedCommandType.getByName(jsonMap['type']),
      name: jsonMap['name'],
      command: jsonMap['command'],
      mapCommand: jsonMap['mapCommand'],
      functionLabel: jsonMap['functionLabel'],
      description: jsonMap['description'],
    );
  }

  Future<ModelCommand> saveAs(
      {required String commandGroupID,
      required SharedPreferences sharedPreferences}) async {
    String data = toJson();
    String idSharePref = "${commandGroupID}_cmd_model_$id";
    await sharedPreferences.setString(idSharePref, data);
    return this;
  }

  Future<ModelCommand> save() async {
    final SharedPreferences preferencesInstance =
        await SharedPreferences.getInstance();
    String data = toJson();
    preferencesInstance.setString(id, data);
    return this;
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
