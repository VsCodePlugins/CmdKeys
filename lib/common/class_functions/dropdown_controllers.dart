import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropDownController with ChangeNotifier {
  late String _selectedValue;
  late List<String> _values ;
  final FocusNode focusNode;
  late SharedPreferences _pref;
  String  sharedPreferencesName;
  bool changeValue = false;
  
  DropDownController(this.focusNode, this.sharedPreferencesName, this._values, ) {
    _values = values;
    _selectedValue = values.first;
    loadSavedData();
  }

  String? get selectedValue => _selectedValue;

  List<String> get values => _values;

  void _setSelectedValue(String value) {
    if (_selectedValue == value) {
      changeValue = false;
    }else {
      changeValue = true;
    }

    _selectedValue = value;
    notifyListeners();
  }



  loadSavedData() async {
    _pref = await SharedPreferences.getInstance();
      _selectedValue = _pref.getString(sharedPreferencesName) ?? values.first;
      print(_selectedValue);
    notifyListeners();

  }

  saveSelectedOption(String option) async {
      _setSelectedValue(option);
      focusNode.previousFocus();
    await _pref.setString(sharedPreferencesName, option);
  }


}


class DropDownSuffixCtrl extends DropDownController {
  DropDownSuffixCtrl(super.focusNode, super.sharedPreferencesName, super.values);
}
class DropDownPrefixCtrl extends DropDownController {
  DropDownPrefixCtrl(super.focusNode, super.sharedPreferencesName, super.values);
}