import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/common/class_functions/grid_controller.dart';
import 'package:vsckeyboard/common/constants.dart';
import 'package:vsckeyboard/common/widgets/json_widget.dart';
import 'package:vsckeyboard/common/widgets/standard_button.dart';
import 'package:vsckeyboard/common/widgets/switch_setting.dart';
import 'package:vsckeyboard/common/widgets/tab_command_group.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

class AllCommands extends StatelessWidget {
  final KeyboardSettingController keyboardSettingController;
  final MainController mainController;
  final double widthTabContainer;
  const AllCommands({
    super.key,
    required this.keyboardSettingController,
    required this.mainController,
    required this.widthTabContainer,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GridController(
              keyboardSettingController.currentBtnProperty,
              mainController,
              keyboardSettingController,
              widthTabContainer: widthTabContainer,
              currentCommandGroupName: Constants.firstGroupCommandName,
            ),
        builder: (context, child) {
          GridController gridController = context.watch<GridController>();
          return OrientationBuilder(builder: (context, orientation) {
            late double height;
            if (orientation == Orientation.portrait) {
              height = MediaQuery.of(context).size.height;
            } else {
              height = MediaQuery.of(context).size.width;
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: TabCommandGroup(
                  gridController: gridController,
                  keyboardSettingController: keyboardSettingController,
                  mainController: mainController,
                  width: MediaQuery.of(context).size.width,
                  height: height,
                  widgetHeader: SizedBox(
                      height: 45,
                      child: StreamBuilder<Map<String, dynamic>>(
                          stream: gridController.gridStreamState,
                          builder: (context, snapshot) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SwitchSetting(
                                  edgeInsets: const EdgeInsets.all(0),
                                  isDarkMode:
                                      keyboardSettingController.darkMode,
                                  state: snapshot.data?["editMode"] ?? false,
                                  label: "Edit Mode",
                                  notify: () {},
                                  height: 45,
                                  functionOnChange: gridController.setEditMode,
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.decelerate,
                                  height: (!gridController.editMode) ? 50 : 0,
                                  child: (!gridController.editMode)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            StandardButton(
                                              functionOnPress:
                                                  gridController.addNewDebugRow,
                                              childWidget: const Icon(
                                                Icons.add_sharp,
                                                color: Colors.blueAccent,
                                              ),
                                              backgroundColor:
                                                  Colors.blue.withOpacity(.5),
                                              width: 70,
                                              height: 30,
                                              text: null,
                                            ),
                                            if (gridController.currentGridModel
                                                        .selectedRow[
                                                    "created_by_user"] ==
                                                "true")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: StandardButton(
                                                  functionOnPress:
                                                      gridController
                                                          .removeDebugRow,
                                                  childWidget: const Icon(
                                                    Icons
                                                        .remove_circle_outline_rounded,
                                                    color: Colors.red,
                                                  ),
                                                  backgroundColor: Colors.blue
                                                      .withOpacity(.5),
                                                  width: 70,
                                                  height: 30,
                                                  text: null,
                                                ),
                                              ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                )
                              ],
                            );
                          })),
                  widgetFooter: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<Map<String, dynamic>>(
                          stream: gridController.gridStreamState,
                          builder: (context, snapshot) {
                            return JsonWidget(
                                dataMap: snapshot.data?["MapRow"]);
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: StreamBuilder<Map<String, dynamic>>(
                            stream: gridController
                                .keyboardSettingCtrl.keyboardSettingStreamState,
                            builder: (context, snapshot) {
                              String commandId = gridController
                                  .currentListModelCommand![
                                      gridController.currentIndex]
                                  .id;
                              return (snapshot.data?["incomingMessage"] !=
                                          null &&
                                      snapshot.data?["incomingMessage"]
                                              ["eventID"]
                                          .contains(commandId))
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .2,
                                      child: JsonWidget(
                                          dataMap: snapshot
                                              .data?["incomingMessage"]),
                                    )
                                  : const SizedBox.shrink();
                            }),
                      ),
                    ],
                  )),
            );
          });
        });
  }
}
