import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
  final Uri _url = Uri.parse('https://www.vscodekeyboard.com');

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
  Future<void> openUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}


updateInterface(){
notifyListeners();
}

}