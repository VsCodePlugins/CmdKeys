import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:fkeys/common/class_functions/scroll_physics.dart';
import 'package:fkeys/features/0_home/%20models/pages.dart';
import 'package:fkeys/features/0_home/controllers/home_controller.dart';
import 'package:fkeys/features/1_keyboard/%20models/button_properties.dart';
import 'package:fkeys/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';
import '../controllers/main_controller.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  bool isMobile = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        isMobile = true;
      }
    }
    return (widget.mainController.listBtnProperties.isNotEmpty)
        ? widget.keyboardSettingController.listMode
            ? AnimatedReorderableListView(
                key: widget.mainController.keyCommandBtnScroll,
                physics: const PositionRetainedScrollPhysics(),
                controller: widget.mainController.listCommandBtnScroll,
                items: widget.mainController.listBtnProperties,
                scrollDirection: widget.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  return ItemCommand(
                    key: ValueKey("${index}_ItemCommand"),
                    widget: widget,
                    index: index,
                  );
                },
                enterTransition: [FlipInX(), ScaleIn()],
                exitTransition: [SlideInLeft()],
                insertDuration: const Duration(milliseconds: 300),
                removeDuration: const Duration(milliseconds: 300),
                onReorderStart: (a) {
                  print(a);

                  if (isMobile) {
                    Vibration.vibrate(duration: 100, amplitude: 255);
                  }
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    onReorderStartEvent(oldIndex, newIndex,
                        widget.mainController.listBtnProperties, isMobile);
                  });
                },
              )
            : AnimatedReorderableGridView(
                enterTransition: [
     FadeIn(
        duration: const Duration(milliseconds: 300),
        delay: const Duration(milliseconds: 100)),
     ScaleIn(
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceInOut)
    ],
                key: widget.mainController.keyCommandBtnScroll,
                physics: const PositionRetainedScrollPhysics(),
                controller: widget.mainController.listCommandBtnScroll,
                items: widget.mainController.listBtnProperties,
                scrollDirection: widget.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  return ItemCommand(
                    key: ValueKey("${index}_ItemCommand"),
                    widget: widget,
                    index: index,
                  );
                },
                //enterTransition: [FlipInX(), ScaleIn()],
                exitTransition: [SlideInLeft()],
                insertDuration: const Duration(milliseconds: 300),
                removeDuration: const Duration(milliseconds: 300),
                
                onReorderStart: (a) {
                  print(a);

                  if (isMobile) {
                    Vibration.vibrate(duration: 100, amplitude: 255);
                  }
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    onReorderStartEvent(oldIndex, newIndex,
                        widget.mainController.listBtnProperties, isMobile);
                  });
                },
                sliverGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        widget.keyboardSettingController.gridColumnNumber),
              )
        : const SizedBox.shrink();
  }

  void onReorderStartEvent(int oldIndex, int newIndex,
      List<BtnProperty> listBtnProperties, bool isMobile) {
    BtnProperty btnProperty = listBtnProperties[oldIndex];
    btnProperty.index = newIndex;
    btnProperty.save();

    BtnProperty nextBtnProperty = listBtnProperties[newIndex];
    nextBtnProperty.index = oldIndex;
    nextBtnProperty.save();
    btnProperty = listBtnProperties.removeAt(oldIndex);
    listBtnProperties.insert(newIndex, btnProperty);
    listBtnProperties.sort(
      (a, b) => a.index.compareTo(b.index),
    );
    if (isMobile) {
      Vibration.vibrate(duration: 100, amplitude: 255);
    }
  }
}

class ItemCommand extends StatelessWidget {
  const ItemCommand({
    super.key,
    required this.widget,
    required this.index,
  });

  final ListCommands widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
        key: ValueKey("${index}_container"),
        padding: EdgeInsets.all(widget.padding),
        child: Stack(
          children: [
            SizedBox(
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
                      listBtnProperty: widget.mainController.listBtnProperties,
                      index: index,
                      keyboardSettingCtrl: widget.keyboardSettingController,
                      homeController: widget.homeController,
                      key: ValueKey("${index}_btn"),
                    ))),
            if (widget.keyboardSettingController.lockKeyboard)
              const Positioned(
                  top: 0,
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white54,
                  )),
            if (!widget.keyboardSettingController.listMode &&
                widget.keyboardSettingController.lockKeyboard)
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      widget.keyboardSettingController.currentBtnProperty =
                          widget.mainController.listBtnProperties[index];
                      widget.homeController.changePage(PagesApp.settingsKey);
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color:
                          widget.mainController.listBtnProperties[index].color,
                    )),
              )
          ],
        ));
  }
}
