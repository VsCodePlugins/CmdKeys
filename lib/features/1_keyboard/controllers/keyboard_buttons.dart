import 'package:vsckeyboard/common/class_functions/command_controller.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';

class KeyBoardButtons with CommandsController  {
  List<BtnProperty> listBtnProperties;
  final String keyBoardName;

  KeyBoardButtons(this.keyBoardName, {required this.listBtnProperties});

  void saveListBtnProperties() {
    for (var i = 0; i < listBtnProperties.length; i++) {
      listBtnProperties[i].saveAs(groupName: keyBoardName);
    }
  }

  void loadListBtnProperties() async {
    for (var i = 0; i < listBtnProperties.length; i++) {
      BtnProperty value = await BtnProperty.getBtProperty(groupName: keyBoardName, index: i);
      listBtnProperties.add(value);
    }
  }

}


