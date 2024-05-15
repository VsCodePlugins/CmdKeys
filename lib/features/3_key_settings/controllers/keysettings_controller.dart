import 'package:flutter/material.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';

class KeySettingsController with ChangeNotifier { 
  final textControllerNameBtn =  TextEditingController();
 final BtnProperty? currentBtnProperty;
final   FocusNode focusNode = FocusNode();

  KeySettingsController({required this.currentBtnProperty}){
    textControllerNameBtn.text = currentBtnProperty!.functionLabel;

  } 

  void setNewIcon(String IconName){

  }


}
