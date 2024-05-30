
import 'package:flutter/material.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import '../controllers/main_controller.dart';
import 'slidable_btn_action.dart';

class ListCommands extends StatefulWidget {
  const ListCommands({
    super.key,
    required this.padding,
    required this.sizeBtn,
    required this.mainController,
    required this.orientation,
    required this.keyboardSettingController,
    required this.homeController,
  });

  final double padding;
  final double sizeBtn;
  final MainController mainController;
  final Orientation orientation;
  final KeyboardSettingController keyboardSettingController;
  final HomeController homeController;
  @override
  State<ListCommands> createState() => _ListCommandsState();
}

class _ListCommandsState extends State<ListCommands> {
  Offset distance = const Offset(6, 6);
  double blur = 16.0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: widget.orientation == Orientation.landscape
            ? Axis.horizontal
            : Axis.vertical,
        padding: const EdgeInsets.only(left:10, right: 10, bottom: 10),
        itemCount: widget.mainController.listBtnProperties.length,
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
                          key: GlobalKey(),
                          parentWidget: widget,
                          listBtnProperty:
                              widget.mainController.listBtnProperties,
                          index: index, 
                          keyboardSettingCtrl: widget.keyboardSettingController,
                          homeController: widget.homeController,))));
        });
  }
}

