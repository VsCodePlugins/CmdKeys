import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class BtnProperty  {
   
   Size sizeIcon;
   int index;
   String iconName;
   String functionName;
   String functionLabel;
   Map<String,String> functionCommand;
   Color color;
   bool isLastPressed ;
  int counter ;

   


  BtnProperty(
      {required this.sizeIcon,
      required this.index,
      required this.iconName,
      required this.functionName,
      required this.functionLabel,
      required this.functionCommand,
      required this.color,
      this.isLastPressed = false,
      this.counter = 0,

      
      });



  String toJson() {
    return  jsonEncode({
      'sizeIcon': sizeIcon.width,
      'index': index,
      'icon': iconName,
      'functionName': functionName,
      'functionLabel': functionLabel,
      'functionCommand': functionCommand["command"],
      'color': color.value,
      'isLastPressed': isLastPressed,
      'counter': counter,
    });
  }

  void increaseCounter() {
    counter++;

  }

void clearCounter() {
    counter = 0;
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
          functionCommand:{"command": data['functionCommand']},
          color: Color(data['color']),
          isLastPressed: data['isLastPressed'],
          counter: data['counter']);
          
          

    }else{
      return BtnProperty(
          sizeIcon: const Size(50, 50),
          index: index,
          iconName: "newBox",
          functionName: "default",
          functionLabel: "Default",
          functionCommand: {"command":"default"},
          color: Colors.grey,
          isLastPressed: false,
          counter: 0);
          }
    
  }
}




 