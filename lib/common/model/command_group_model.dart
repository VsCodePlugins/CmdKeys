import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'command_types.dart';
import 'grid_model.dart';

class ModelCommandGroup {
  String id;
  final String name;
  final String description;
  final String label;
  late int? created;
  final int? updated;
  final CommandType onlyType;

  ModelCommandGroup({
    this.id = "",
    required this.onlyType,
    required this.name,
    required this.description,
    required this.label,
    this.created,
    this.updated,
  }) {
    if (id == "") {
      var uuid = const Uuid();
      id = uuid.v1();
    }
    created ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'onlyType': onlyType.name,
      'name': name,
      'description': description,
      'label': label,
      'created': created,
      'updated': updated
    });
  }

  static ModelCommandGroup fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return ModelCommandGroup(
      id: jsonMap['id'],
      onlyType: ExtendedCommandType.getByName(jsonMap['onlyType']),
      name: jsonMap['name'],
      description: jsonMap['description'],
      label: jsonMap['label'],
      created: jsonMap['created'],
      updated: jsonMap['updated'],
    );
  }

  ModelCommandGroup save(SharedPreferences preferencesInstance) {
    String data = toJson();
    preferencesInstance.setString(id, data);
    return this;
  }

  ModelCommandGroup saveAs(
      {required String keyBaseCommandGroup,
      required SharedPreferences sharedPreferences}) {
    String data = toJson();
    String idSharePref = "${keyBaseCommandGroup}_cmd_group_$id";
    sharedPreferences.setString(idSharePref, data);
    return this;
  }

  static ModelCommandGroup? loadCommandGroup(
      {required String key, required SharedPreferences sharedPreferences}) {
    String? commandStr = sharedPreferences.getString(key);
    if (commandStr == null) {
      return null;
    }
    ModelCommandGroup model = ModelCommandGroup.fromJson(commandStr);
    return model;
  }
}
