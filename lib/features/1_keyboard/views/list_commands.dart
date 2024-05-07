
import 'package:flutter/material.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import '../controllers/dashboard.dart';
import 'slidable_command.dart';

class ListCommands extends StatefulWidget {
  const ListCommands({
    super.key,
    required this.padding,
    required this.sizeBtn,
    required this.panelDashBoard,
    required this.orientation,
    required this.keyboardSettingController,
  });

  final double padding;
  final double sizeBtn;
  final PanelDashBoard panelDashBoard;
  final Orientation orientation;
  final KeyboardSettingController keyboardSettingController;
  @override
  State<ListCommands> createState() => _ListCommandsState();
}

class _ListCommandsState extends State<ListCommands> {
  Offset distance = Offset(6, 6);
  double blur = 16.0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: widget.orientation == Orientation.landscape
            ? Axis.horizontal
            : Axis.vertical,
        padding: const EdgeInsets.all(10),
        itemCount: widget.panelDashBoard.listBtnProperties.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.all(widget.padding),
              child: SizedBox(
                  height: widget.orientation == Orientation.landscape
                      ? null
                      : widget.sizeBtn,
                  width: widget.orientation == Orientation.landscape
                      ? widget.sizeBtn
                      : null,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SlidableCommand(
                          parentWidget: widget,
                          listBtnProperty:
                              widget.panelDashBoard.listBtnProperties,
                          index: index, 
                          keyboardSettingCtrl: widget.keyboardSettingController,))));
        });
  }
}

