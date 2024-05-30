import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'command_types.dart';

class ModelCommand {
  late String id;
  final int index;
  final String name;
  final Map<String, dynamic>? mapCommand;
  final String functionLabel;
  final String description;
  final CommandType type;
  final bool deletable;

  ModelCommand({
    this.id = "",
    required this.index,
    required this.type,
    required this.name,
    this.mapCommand,
    required this.functionLabel,
    required this.description,
    this.deletable =true,
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
      'mapCommand': mapCommand,
      'functionLabel': functionLabel,
      'description': description,
      'deletable':deletable
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'index': index,
      'type': type.name,
      'name': name,
      'mapCommand': mapCommand,
      'functionLabel': functionLabel,
      'description': description,
      'deletable':deletable
    };
  }

  static ModelCommand fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return ModelCommand(
      id: jsonMap['id'],
      index: jsonMap['index'],
      type: ExtendedCommandType.getByName(jsonMap['type']),
      name: jsonMap['name'],
      mapCommand: jsonMap['mapCommand'],
      functionLabel: jsonMap['functionLabel'],
      description: jsonMap['description'],
      deletable: jsonMap['deletable'],
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

  static Future<ModelCommand?> update(
      {required SharedPreferences sharedPreferences,
      required String id,
      required Map<String, dynamic> mapModel}) async {
    ModelCommand? commandModel;
    Set<String>? commandStr = sharedPreferences.getKeys();

    String? key = commandStr.firstWhere(
        (element) => element.contains(id) && element.contains("_cmd_model_"));
    commandModel =
        await loadCommand(key: key, sharedPreferences: sharedPreferences);

    late Map<String, dynamic> commandModelToMap;
    if (commandModel != null) {
      commandModelToMap = commandModel.toMap();
      mapModel.forEach((k, v) {
        commandModelToMap[k] = v;
      });
    }
    String modelJsonStr = jsonEncode(commandModelToMap);

    sharedPreferences.setString(key, modelJsonStr);

    return commandModel;
  }


    static Future<bool?> delete(
      {required SharedPreferences sharedPreferences,
      required String id,}) async {
    ModelCommand? commandModel;
    Set<String>? commandStr = sharedPreferences.getKeys();

    String? key = commandStr.firstWhere(
        (element) => element.contains(id) && element.contains("_cmd_model_"));
    
    
    commandModel =
        await loadCommand(key: key, sharedPreferences: sharedPreferences);

    if (commandModel != null) {
      sharedPreferences.remove(key);
      return true;
    }
    return false;
  
  }

  static Future<ModelCommand?> loadCommand(
      {required String key,
      required SharedPreferences sharedPreferences}) async {
    String? commandStr = sharedPreferences.getString(key);
    if (commandStr == null) {
      return null;
    }
    ModelCommand model = ModelCommand.fromJson(commandStr);
    return model;
  }
}
