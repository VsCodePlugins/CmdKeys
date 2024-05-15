import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:vsckeyboard/features/0_home/%20models/pages.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';
import 'package:vsckeyboard/features/1_keyboard/views/command_button.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

import 'list_commands.dart';

class SlidableCommand extends StatefulWidget {
  const SlidableCommand({
    super.key,
    required this.parentWidget,
    required this.listBtnProperty,
    required this.index,
    required this.keyboardSettingCtrl,
    required this.homeController,
  });

  final ListCommands parentWidget;
  final List<BtnProperty> listBtnProperty;
  final int index;
  final KeyboardSettingController keyboardSettingCtrl;
  final HomeController homeController;
  @override
  State<SlidableCommand> createState() => _SlidableCommandState();
}

class _SlidableCommandState extends State<SlidableCommand> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey("${widget.index}_slidable"),
      direction: widget.parentWidget.orientation == Orientation.landscape
          ? Axis.vertical
          : Axis.horizontal,
      startActionPane: ActionPane(
        key: ValueKey("${widget.index}_start"),
        motion: const ScrollMotion(),
        children: [
          Padding(
            padding: widget.parentWidget.orientation == Orientation.landscape
                ? const EdgeInsets.only(top: 20.0)
                : const EdgeInsets.only(left: 20.0),
            child: ElevatedButton(
              onPressed: () {
                widget.keyboardSettingCtrl.currentBtnProperty =
                    widget.listBtnProperty[widget.index];
                widget.homeController.changePage(PagesApp.settingsKey);
              },
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  backgroundColor: widget.keyboardSettingCtrl.darkMode
                      ? Colors.grey[900]
                      : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              child: const Center(
                child: Icon(
                  Icons.settings,
                  color: Colors.blueAccent,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      endActionPane: ActionPane(
        key: ValueKey("${widget.index}_end"),
        motion: const ScrollMotion(),
        children: [
          Padding(
              padding: widget.parentWidget.orientation == Orientation.landscape
                  ? const EdgeInsets.only(top: 20.0)
                  : const EdgeInsets.only(left: 20.0),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: widget.listBtnProperty[widget.index].counter == 0
                      ? null
                      : () {
                          widget.keyboardSettingCtrl.resetCounter(widget.index);
                          if (Platform.isAndroid || Platform.isIOS) {
                            Vibration.vibrate(duration: 200, amplitude: 255);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: widget.keyboardSettingCtrl.darkMode
                          ? Colors.grey[900]
                          : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  child: Center(
                    child: Icon(
                      MdiIcons.counter,
                      color: widget.listBtnProperty[widget.index].counter == 0
                          ? Colors.grey
                          : Colors.blueAccent,
                      size: 30,
                    ),
                  ),
                ),
              )),
        ],
      ),
      child: ButtonFunction(
          btnProperty: widget.listBtnProperty[widget.index],
          panelDashBoard: widget.parentWidget.panelDashBoard,
          keyboardSettingCtrl: widget.keyboardSettingCtrl),
    );
  }
}
