import 'dart:async';

import 'package:flutter/material.dart';

class HomeMenuController with ChangeNotifier {
  final  Stream<Map<String,dynamic>> mainSteamState;
    bool isMenuOpen = false;

  HomeMenuController({required this.mainSteamState}){

     mainSteamState.listen((Map<String,dynamic> data) { 
      if(data.containsKey('isMenuOpen')){
        isMenuOpen = data['isMenuOpen'];
        notifyListeners();
      }
    }); 


  
  }


}