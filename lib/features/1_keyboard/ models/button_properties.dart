import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BtnProperty {
  late String id;
  Size sizeIcon;
  int index;
  String iconName;
  String functionName;
  String functionLabel;
  String idCommand;
  Map<String, dynamic>? mapCommand;
  Color color;
  bool isLastPressed;
  int counter;
  bool isEnable;

  BtnProperty({
    this.id = "",
    required this.sizeIcon,
    required this.index,
    required this.iconName,
    required this.functionName,
    required this.functionLabel,
    required this.idCommand,
    this.mapCommand,
    required this.color,
    this.isLastPressed = false,
    this.counter = 0,
    this.isEnable = true,
  }) {
    if (id == "") {
      var uuid = const Uuid();
      id = "_btn_${uuid.v1()}";
    }
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'sizeIcon': sizeIcon.width,
      'index': index,
      'icon': iconName,
      'functionName': functionName,
      'functionLabel': functionLabel,
      'idCommand': idCommand,
      'mapCommand': mapCommand,
      'color': color.value,
      'isLastPressed': isLastPressed,
      'counter': counter,
      'isEnable': isEnable,
    });
  }

  void increaseCounter() {
    counter++;
  }

  void clearCounter() {
    counter = 0;
  }

  dynamic commandSelector() {
      return mapCommand;
    }
  

  void saveAs({required String groupName}) async {
    final SharedPreferences preferencesInstance =
        await SharedPreferences.getInstance();
    String data = toJson();
    id = id.split("_btn_").last;
    id = "${groupName}_btn_$id";
    preferencesInstance.setString(id, data);
  }

  void save() async {
    final SharedPreferences preferencesInstance =
        await SharedPreferences.getInstance();
    String data = toJson();
    preferencesInstance.setString(id, data);
  }

  static Future<BtnProperty> getBtProperty(
      {required String groupName, required int index}) async {
    final SharedPreferences preferencesInstance =
        await SharedPreferences.getInstance();
    Set<String> setLeys = preferencesInstance.getKeys();
    List<String> listKeyBtn;
    List<String?>? listDataStr;
    Map<String, dynamic>? mapBtnProperty;
    try {
      listKeyBtn = setLeys
          .where((keyName) =>
              keyName.contains(groupName) && keyName.contains("_btn_"))
          .toList();

      listDataStr =
          listKeyBtn.map((e) => preferencesInstance.getString(e)).toList();
          
      mapBtnProperty = listDataStr
          .map((e) => Map<String, dynamic>.from(jsonDecode(e!)))
          .firstWhere((element) => element["index"] == index);
      // ignore: empty_catches
    } catch (e) {}

    if (mapBtnProperty != null) {
      return BtnProperty(
          id: mapBtnProperty['id'],
          sizeIcon:
              Size(mapBtnProperty['sizeIcon'], mapBtnProperty['sizeIcon']),
          index: mapBtnProperty['index'],
          iconName: mapBtnProperty['icon'],
          functionName: mapBtnProperty['functionName'],
          functionLabel: mapBtnProperty['functionLabel'],
          idCommand: mapBtnProperty['idCommand'],
          mapCommand: mapBtnProperty['mapCommand'],
          color: Color(mapBtnProperty['color']),
          isLastPressed: mapBtnProperty['isLastPressed'],
          counter: mapBtnProperty['counter'],
          isEnable: mapBtnProperty['isEnable'] ?? false);
    } else {
      return BtnProperty(
          sizeIcon: const Size(50, 50),
          index: 0,
          iconName: "newBox",
          functionName: "default",
          functionLabel: "Default",
          idCommand: "default_command",
          mapCommand: {"showMessage": "Hello Word"},
          color: Colors.grey,
          isLastPressed: false,
          counter: 0,
          isEnable: false);
    }
  }
}
