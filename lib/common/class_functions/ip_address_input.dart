import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputValid {
  static TextInputFormatter ipAddressInputFilter() {
    return FilteringTextInputFormatter.allow(RegExp("[0-9.]"));
  }

    static TextInputFormatter ipAddressInputFilterWithPort() {
    return FilteringTextInputFormatter.allow(RegExp("[:0-9.]"));
  }
  static TextInputFormatter urlInputFilter() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9./:]"));
  }
}

class IpAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int dotCounter = 0;
    var buffer = StringBuffer();
    String ipField = "";

    for (int i = 0; i < text.length; i++) {

      if (text.contains(":")) {
        int countDoubleDot  = text.split(":").length - 1;
        String rawValue =  text.split(":")[1];

        int countAfterDoubleDot = rawValue.length;
        int portNumber = 80;

        if (rawValue.isNotEmpty) {
          portNumber = int.parse(rawValue);
        }
      if (countAfterDoubleDot > 5 || portNumber > 65535 || countDoubleDot > 1 )  {
      var string = oldValue.text;
      
      return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
        }

    var string = text;

    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));

      }

      if (dotCounter < 4) {
        if (text[i] != ".") {
          ipField += text[i];
          if (ipField.length < 3) {
            buffer.write(text[i]);
          } else if (ipField.length == 3) {
            if (int.parse(ipField) <= 255) {
              buffer.write(text[i]);
            } else {
              if (dotCounter < 3) {
                buffer.write(".");
                dotCounter++;
                buffer.write(text[i]);
                ipField = text[i];
              }
            }
          } else if (ipField.length == 4) {
            if (dotCounter < 3) {
              buffer.write(".");
              dotCounter++;
              buffer.write(text[i]);
              ipField = text[i];
            }
          }
        } else {
          if (dotCounter < 3) {
            buffer.write(".");
            dotCounter++;
            ipField = "";

          }
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
