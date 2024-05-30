import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/common/class_functions/grid_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'grid_commands.dart';

class TabCommands extends StatelessWidget {
  const TabCommands({
    super.key,
    required this.gridController,
    required this.width,
    required this.height,
    required this.keyboardSettingCtrl,
    required this.mainController,
    required this.widgetFooter,
    required  this.widgetHeader,
  });
  final MainController mainController;
  final GridController gridController;
  final double width;
  final double height;
  final KeyboardSettingController keyboardSettingCtrl;
  final Widget widgetFooter;
  final Widget? widgetHeader;

  @override
  Widget build(BuildContext context) {
    return TabContainer(
      tabEdge: TabEdge.top,
      tabsStart: 0.1,
      tabsEnd: 0.9,
      tabMaxLength: 200,
      borderRadius: BorderRadius.circular(20),
      tabBorderRadius: BorderRadius.circular(12),
      childPadding: const EdgeInsets.all(4.0),
      selectedTextStyle: const TextStyle(
        color: Colors.blueAccent,
        fontSize: 15.0,
      ),
      unselectedTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14.0,
      ),
      colors: [
        Colors.blueAccent.withOpacity(.1),
        Colors.blueAccent.withOpacity(.1),
        Colors.blueAccent.withOpacity(.1),

      ],
      tabs: List.generate(gridController.commandGroups.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(gridController.commandGroups[index].label),
        );
      }),
      children: [
        (gridController.columnCommandsTable.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.all(0.0),
                child: Theme(
                    data: ThemeData(
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: Colors.blue,
                          selectionColor: Colors.blue[300],
                          selectionHandleColor: Colors.blueAccent,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              )),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          )),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(
                              color: keyboardSettingCtrl.darkMode
                                  ? Colors.white
                                  : Colors.black),
                          prefixStyle: TextStyle(
                              color: keyboardSettingCtrl.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                          hintStyle: TextStyle(
                              color: keyboardSettingCtrl.darkMode
                                  ? const Color.fromARGB(255, 66, 66, 66)
                                  : const Color.fromARGB(255, 201, 201, 201)),
                        ),
                        hintColor: Colors.blueAccent,
                        textButtonTheme: TextButtonThemeData(
                            style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.blueAccent),
                        )),
                        radioTheme: RadioThemeData(fillColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.blueAccent.withOpacity(.32);
                          }
                          return Colors.blueAccent;
                        }))),
                    child: CommandsGrid(
                      mainController: mainController,
                      gridController: gridController,
                      keyboardSettingController: keyboardSettingCtrl,
                      widgetFooter: widgetFooter,
                      widgetHeader: widgetHeader,
                    )))
            : const SizedBox.shrink(),
       
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height,
          child: const Text("2"),
        ),
         
      ],
    );
  }
}
