import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fkeys/common/model/command_model.dart';
import 'package:fkeys/common/model/command_types.dart';
import 'package:fkeys/features/1_keyboard/%20models/button_properties.dart';
import 'package:fkeys/features/1_keyboard/controllers/main_controller.dart';

class KeySettingsController with ChangeNotifier {
  final textControllerNameBtn = TextEditingController();
  final MainController mainController;
  BtnProperty? currentBtnProperty;
  final FocusNode focusNode = FocusNode();
  final List<String> listNameIcons = MdiIcons.getNames();
  late Map<String, IconPickerIcon> mapIconsName;
  late Map<int, String> mapCodePointIconsName;
  ModelCommand? currentCommand;

  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;
  late final Map<ColorSwatch<Object>, String> colorsNameMap;

  IconPickerIcon _getIconDataWithName(String nameIcon) {
    return IconPickerIcon( name: nameIcon ,
      data: MdiIcons.fromString(nameIcon) ?? Icons.close, pack: IconPack.material) ;
  }

  KeySettingsController({required this.mainController, required this.currentBtnProperty}) {
    textControllerNameBtn.text = currentBtnProperty!.functionLabel;
    mapIconsName = {
      for (var nameIcon in listNameIcons)
        nameIcon: _getIconDataWithName(nameIcon)
    };

    mapCodePointIconsName = {
      for (var nameIcon in listNameIcons)
        _getIconDataWithName(nameIcon).data.codePoint: nameIcon
    };

    screenPickerColor = Colors.blue; // Material blue.
    dialogPickerColor = Colors.red; // Material red.
    dialogSelectColor = const Color(0xFFA239CA); //

    // Make a custom ColorSwatch to name map from the above custom colors.
    colorsNameMap = <ColorSwatch<Object>, String>{
      ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
      ColorTools.createPrimarySwatch(guidePrimaryVariant):
          'Guide Purple Variant',
      ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
      ColorTools.createAccentSwatch(guideSecondaryVariant):
          'Guide Teal Variant',
      ColorTools.createPrimarySwatch(guideError): 'Guide Error',
      ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
      ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
    };


    getModelCommandBtnProperty();

  }

  _setNewIcon(IconData iconSelected) {
    String? nameIcon = mapCodePointIconsName[iconSelected.codePoint];
    currentBtnProperty!.iconName = nameIcon!;
    currentBtnProperty!.save();
    notifyListeners();
  }

  assignCommand({required String idModelCommand,required  CommandType commandType}) async {
    currentCommand = await getModelCommandById(idModelCommand);
    if (currentBtnProperty == null) {
      return;
    }
      currentBtnProperty!.mapCommand = currentCommand!.mapCommand;
      currentBtnProperty!.idCommand = currentCommand!.id;
      currentBtnProperty!.save();
    

    notifyListeners();
  }

  Future<ModelCommand?> getModelCommandBtnProperty(
      {BtnProperty? btnProperty}) async {
    if (btnProperty != null) {
      currentBtnProperty = btnProperty;
    }
    if (currentBtnProperty == null) {
      return null;
    }
    currentCommand = await getModelCommandById(currentBtnProperty!.idCommand);
    notifyListeners();
    return currentCommand;
  }

  Future<ModelCommand?> getModelCommandById(String idCommand) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Set<String> listKeys = sharedPreferences.getKeys();
    String keyModelCommand = listKeys.firstWhere(
      (element) =>
          element.contains(idCommand) && element.contains("_cmd_model_"),
    );
    currentCommand = await ModelCommand.loadCommand(
        key: keyModelCommand, sharedPreferences: sharedPreferences);

    return currentCommand;
  }

  openIconsMenu(context) async {
    //FocusManager.instance.primaryFocus?.previousFocus();
    //FocusManager.instance.primaryFocus?invokeMethod();
    SinglePickerConfiguration singlePickerConfiguration = SinglePickerConfiguration(adaptiveDialog: true, customIconPack: mapIconsName);
    IconPickerIcon? iconSelected = await showIconPicker(context,configuration: singlePickerConfiguration
        );

    if (iconSelected != null) {
      _setNewIcon(iconSelected.data);
    }
  }

  _changeColor(Color color) {
    currentBtnProperty!.color = color;
    currentBtnProperty!.save();
    notifyListeners();
  }

  changeName(String name) {
    currentBtnProperty!.functionLabel = name;
    currentBtnProperty!.save();
  }

  Future<bool> colorPickerDialog(BuildContext context) async {
    callbackChangeColor(Color color) {
      dialogPickerColor = color;
      _changeColor(color);
    }

    return ColorPicker(
      // Use the dialogPickerColor as start and active color.
      color: dialogPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: callbackChangeColor,
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      //materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      pickerTypeTextStyle: const TextStyle(color: Colors.blueAccent),
      materialNameTextStyle: const TextStyle(color: Colors.blueAccent),
      colorNameTextStyle: const TextStyle(color: Colors.blueAccent),
      colorCodeTextStyle: const TextStyle(color: Colors.blueAccent),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
}
