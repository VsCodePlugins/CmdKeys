import 'dart:io';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:vibration/vibration.dart';
import 'package:vsckeyboard/common/widgets/icon_command.dart';
import 'package:vsckeyboard/common/widgets/toast.dart';
import 'package:vsckeyboard/features/0_home/%20models/pages.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';
import '../ models/button_properties.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ButtonFunction extends StatefulWidget {
  final BtnProperty btnProperty;
  final MainController mainController;
  final KeyboardSettingController keyboardSettingCtrl;
  final HomeController homeCtrl;

  const ButtonFunction(
      {super.key,
      required this.btnProperty,
      required this.mainController,
      required this.keyboardSettingCtrl,
      required this.homeCtrl});

  @override
  State<ButtonFunction> createState() => _ButtonFunctionState();
}

class _ButtonFunctionState extends State<ButtonFunction> {
  late bool isNotPressed;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    isNotPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);

    showToast(Widget toast) {
      fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
      );
    }

    bool isTheLastPressed = widget.btnProperty.isLastPressed;
    int counter = widget.btnProperty.counter;
    Offset distance = isNotPressed ? const Offset(3, 3) : const Offset(3, 3);
    double blur = isNotPressed ? 10.0 : 12.0;
    return GestureDetector(
      key: widget.key,
      onTapUp: (widget.keyboardSettingCtrl.lockKeyboard == true)
          ? null
          : (details) async {
              print("on tapUp");
              await Future.delayed(const Duration(milliseconds: 100));
              if (context.mounted) {
                setState(() {
                  isNotPressed = false;
                });
              }
            },
      onTapDown: (widget.keyboardSettingCtrl.lockKeyboard == true)
          ? null
          : (s) async {
              if (!context.mounted) {
                return;
              }
              setState(() {
                isNotPressed = true;
              });

              print("on tapDown");
              widget.mainController
                  .sentCommand(widget.btnProperty.commandSelector(),
                      widget.keyboardSettingCtrl, widget.btnProperty.idCommand)
                  .then((value) {
                if (widget.mainController.showResponses() && value != null) {
                  showToast(MessageToast(
                    message: value.toString(),
                    iconToast: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    isDarkMode: widget.keyboardSettingCtrl.darkMode,
                  ));
                }
              }, onError: (e) {
                if (widget.mainController.showExceptions()) {
                  showToast(MessageToast(
                    message: e.toString(),
                    iconToast: const Icon(
                      Icons.error,
                      color: Colors.orange,
                    ),
                    isDarkMode: widget.keyboardSettingCtrl.darkMode,
                  ));
                }
              });

              if (Platform.isAndroid || Platform.isIOS) {
                Vibration.vibrate(duration: 200);
              }

              await Future.delayed(const Duration(milliseconds: 200));
              widget.keyboardSettingCtrl
                  .setLastPressed(widget.btnProperty.index);
              widget.keyboardSettingCtrl
                  .updateCounter(widget.btnProperty.index);
            },
      onLongPressEnd: (widget.keyboardSettingCtrl.lockKeyboard == true)
          ? null
          : (d) {
              setState(() {
                isNotPressed = false;
              });
            },
      onTapCancel: (widget.keyboardSettingCtrl.lockKeyboard == true)
          ? null
          : () {
              setState(() {
                isNotPressed = false;
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: widget.keyboardSettingCtrl.darkMode
              ? Colors.grey[900]
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: widget.keyboardSettingCtrl.darkMode
                  ? Colors.black
                  : Colors.grey.shade500,
              offset: distance,
              blurRadius: blur,
              spreadRadius: 1,
              inset: isNotPressed,
            ),
            BoxShadow(
              color: widget.keyboardSettingCtrl.darkMode
                  ? Colors.grey.shade800
                  : Colors.white,
              offset: -distance,
              blurRadius: blur - 3,
              spreadRadius: 3,
              inset: isNotPressed,
            ),
          ],
        ),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return CommandButtonContent(
            isLastPressed: isTheLastPressed,
            widget: widget,
            isNotPressed: isNotPressed,
            orientation: MediaQuery.of(context).orientation,
            counter: counter,
            boxConstraintsParent: constraints,
            homeController: widget.homeCtrl,
            btnProperty: widget.btnProperty,
          );
        }),
      ),
    );
  }
}

class CommandButtonContent extends StatelessWidget {
  const CommandButtonContent({
    super.key,
    required this.isLastPressed,
    required this.widget,
    required this.isNotPressed,
    required this.orientation,
    required this.counter,
    required this.boxConstraintsParent,
    required this.btnProperty,
    required this.homeController,
  });

  final bool isLastPressed;
  final ButtonFunction widget;
  final bool isNotPressed;
  final Orientation orientation;
  final int counter;
  final BoxConstraints boxConstraintsParent;
  final BtnProperty btnProperty;
  final HomeController homeController;
  @override
  Widget build(BuildContext context) {
    return (orientation == Orientation.portrait ||
            !widget.keyboardSettingCtrl.listMode)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildButton(true, widget, isNotPressed, isLastPressed,
                counter, boxConstraintsParent, btnProperty, homeController))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildButton(false, widget, isNotPressed, isLastPressed,
                counter, boxConstraintsParent, btnProperty, homeController),
          );
  }
}

List<Widget> buildButton(
    bool isRow,
    ButtonFunction widget,
    bool isNotPressed,
    bool isLastPressed,
    int counter,
    BoxConstraints boxConstraintsParent,
    BtnProperty btnProperty,
    HomeController homeController) {
  return [
    if (boxConstraintsParent.maxWidth > 200)
      SizedBox(
        width: isRow ? 16 : 0,
        height: isRow ? 0 : 16,
      ),
    isLastPressed && boxConstraintsParent.maxWidth > 180
        ? const Padding(
            padding:
                EdgeInsets.only(top: 8.0, left: 8.0, right: 8, bottom: 8.0),
            child: Icon(Icons.circle, size: 10, color: Colors.blueAccent),
          )
        : const SizedBox.shrink(),
    if (widget.keyboardSettingCtrl.lockKeyboard &&
        boxConstraintsParent.maxWidth > 220)
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.lock_outline,
          color: (widget.keyboardSettingCtrl.darkMode)
              ? Colors.grey[800]
              : Colors.black26,
        ),
      ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconBtn(
            isNotPressed: isNotPressed,
            isDarkMode: widget.keyboardSettingCtrl.darkMode,
            size: widget.keyboardSettingCtrl.sizeIcon,
            color: (widget.keyboardSettingCtrl.lockKeyboard)
                ? widget.btnProperty.color.withOpacity(.5)
                : widget.btnProperty.color,
            iconName: widget.btnProperty.iconName,
          ),
          
        ],
      ),
    ),
    if (boxConstraintsParent.maxWidth > 200)
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.btnProperty.functionLabel,
          style: TextStyle(
              fontSize: 17,
              color: (widget.keyboardSettingCtrl.lockKeyboard)
                  ? widget.btnProperty.color.withOpacity(.5)
                  : widget.btnProperty.color),
          overflow: TextOverflow.fade,
        ),
      ),
    if (boxConstraintsParent.maxWidth > 200)
      Counter(
          counter: counter,
          isLastPressed: isLastPressed,
          isDarkMode: widget.keyboardSettingCtrl.darkMode),
  ];
}

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required this.counter,
    required this.isLastPressed,
    required this.isDarkMode,
  });

  final int counter;
  final bool isLastPressed;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    late TextStyle styleText;

    if (isDarkMode) {
      styleText = TextStyle(
          color: isLastPressed
              ? Colors.blueAccent
              : const Color.fromARGB(255, 63, 63, 63),
          fontSize: 20);
    } else {
      styleText = TextStyle(
          color: isLastPressed
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 172, 172, 172),
          fontSize: 20);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        (counter > 0) ? counter.toString() : " ",
        style: styleText,
      ),
    );
  }
}
