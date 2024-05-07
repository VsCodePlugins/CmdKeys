import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';

class KeyBoardCommand {
  List<BtnProperty> listBtnProperties;
  final String keyBoardName;

  KeyBoardCommand(this.keyBoardName, {required this.listBtnProperties});

  void saveListBtnProperties() {
    for (var i = 0; i < listBtnProperties.length; i++) {
      listBtnProperties[i].saveConfig(keyBoardName);
    }
  }

  void loadListBtnProperties() async {
    for (var i = 0; i < listBtnProperties.length; i++) {
      BtnProperty value = await BtnProperty.getBtProperty(keyBoardName, i);
      listBtnProperties.add(value);
    }
  }
}


