import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';

class PickerNumber extends StatefulWidget {
  final int maxValue;
  final int minValue;
  final int value;
  final String text;
  final Function(int) onChangedCallback;
  final KeyboardSettingController keyboardSettingController;

  const PickerNumber(
      {super.key,
      required this.maxValue,
      required this.minValue,
      required this.onChangedCallback,
      required this.value,
      required this.keyboardSettingController,
      required this.text});

  @override
  _PickerNumberState createState() => _PickerNumberState();
}

class _PickerNumberState extends State<PickerNumber> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        Center(
          child: NumberPicker(
            key: ValueKey("${widget.key}_number_picker"),
            itemHeight: 120,
            haptics: true,
            selectedTextStyle:
                const TextStyle(color: Colors.blue, fontSize: 25),
            textStyle: (widget.keyboardSettingController.darkMode)
                ? const TextStyle(color: Colors.white70, fontSize: 18)
                : const TextStyle(color: Colors.black87, fontSize: 18),
            zeroPad: true,
            axis: Axis.horizontal,
            value: _currentValue,
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            onChanged: (value) => setState(() {
              _currentValue = value;
              widget.onChangedCallback(value);
            }),
          ),
        ),
      ],
    );
  }
}
