
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/common/class_functions/dropdown_controllers.dart';

class DropDownPrefix extends StatelessWidget {
  final bool isDarkMode;
  
   const DropDownPrefix({super.key, required this.isDarkMode, });
  @override
  Widget build(BuildContext context) {

    return Consumer<DropDownPrefixCtrl>(
          builder: (context, dropdownCtrl, child) {
        return SizedBox(
          height: 30,
          child: DropdownButton<String>(
            value: dropdownCtrl.selectedValue,
            dropdownColor:isDarkMode? Colors.black54: Colors.white,
            borderRadius: BorderRadius.circular(10),
            underline: const SizedBox.shrink(),
            
            onChanged: (String? newValue) {
              newValue ??= dropdownCtrl.selectedValue;
              dropdownCtrl.saveSelectedOption(newValue!);
            },
            items: dropdownCtrl.values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style:  TextStyle(
                    color: isDarkMode ? Colors.white: Colors.black
                  ),
                ),
              );
            }).toList(),
            isExpanded: false,
          ),
        );
      }
    );
  }
}

class DropDownSuffix extends StatelessWidget {
  final bool isDarkMode;

   const DropDownSuffix({super.key, required this.isDarkMode, });
  @override
  Widget build(BuildContext context) {

    return Consumer<DropDownSuffixCtrl>(
          builder: (context, dropdownCtrl, child) {
        return SizedBox(
          height: 30,
          child: DropdownButton<String>(
            value: dropdownCtrl.selectedValue,
            dropdownColor:isDarkMode? Colors.black54:Colors.white,
            borderRadius: BorderRadius.circular(10),
            underline: const SizedBox.shrink(),
            
            onChanged: (String? newValue) {
              newValue ??= dropdownCtrl.selectedValue;
              dropdownCtrl.saveSelectedOption(newValue!);
            },
            items: dropdownCtrl.values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style:  TextStyle(
                    color: isDarkMode? Colors.white:Colors.black,
                  ),
                ),
              );
            }).toList(),
            isExpanded: false,
          ),
        );
      }
    );
  }
}
