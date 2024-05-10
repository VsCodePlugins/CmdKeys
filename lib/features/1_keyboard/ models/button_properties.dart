import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BtnProperty  {
   
   Size sizeIcon;
   int index;
   String iconName;
   String functionName;
   String functionLabel;
   Map<String,dynamic> ? mapCommand; 
   String ? command;
   Color color;
   bool isLastPressed ;
   int counter ;
   bool isEnable;




  BtnProperty(
      {required this.sizeIcon,
      required this.index,
      required this.iconName,
      required this.functionName,
      required this.functionLabel,
      this.mapCommand,
      required this.command,
      required this.color,
      this.isLastPressed = false,
      this.counter = 0,
      this.isEnable = true,
      });



  String toJson() {
    return  jsonEncode({
      'sizeIcon': sizeIcon.width,
      'index': index,
      'icon': iconName,
      'functionName': functionName,
      'functionLabel': functionLabel,
      'mapCommand': mapCommand,
      'command': command,
      'color': color.value,
      'isLastPressed': isLastPressed,
      'counter': counter,
      'isEnable':isEnable,
    });
  }

  void increaseCounter() {
    counter++;

  }

void clearCounter() {
    counter = 0;
  }

  dynamic commandSelector(){

    if (command != null){
      return command;
    }else{
      if (mapCommand == null){
        throw Exception("This button has no command assigned");
      }
      return mapCommand;
    }
  }

  void saveConfig(String nameList) async {
    final SharedPreferences preferencesInstance =
        await SharedPreferences.getInstance();
    String data = toJson();
    String keyName = "$nameList _${index.toString()}";

    preferencesInstance.setString(keyName, data);
  }

  static Future<BtnProperty> getBtProperty(String nameList, int index) async {
        String keyName = "$nameList _${index.toString()}";

    final SharedPreferences preferencesInstance =
       await SharedPreferences.getInstance();

    String? dataStr = preferencesInstance.getString(keyName);

    if (dataStr != null) {
      Map<String, dynamic>  data =  Map<String, dynamic>.from(jsonDecode(dataStr));
      return BtnProperty(
          sizeIcon: Size(data['sizeIcon'], data['sizeIcon']),
          index: data['index'],
          iconName: data['icon'],
          functionName: data['functionName'],
          functionLabel: data['functionLabel'],
          mapCommand:data['functionCommand'],
          command:data['command'],
          color: Color(data['color']),
          isLastPressed: data['isLastPressed'],
          counter: data['counter'],
          isEnable: data['isEnable']??false);
          
          

    }else{
      return BtnProperty(
          sizeIcon: const Size(50, 50),
          index: index,
          iconName: "newBox",
          functionName: "default",
          functionLabel: "Default",
          mapCommand: {"showMessage":"Hello Word"},
          command: null,
          color: Colors.grey,
          isLastPressed: false,
          counter: 0,
          isEnable: false);
          }
    
  }
}




 