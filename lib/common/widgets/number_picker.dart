import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class PickerNumber extends StatefulWidget {
  
  final int maxValue;
  final int minValue;
  final int value;
  final Function(int) onChangedCallback;

  const PickerNumber({super.key, required this.maxValue, required this.minValue, required this.onChangedCallback, required this.value});

  @override
  _PickerNumberState createState() => _PickerNumberState();
}

class _PickerNumberState extends State<PickerNumber> {
 late  int _currentValue ;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
                const Padding(
                  padding: EdgeInsets.only(left:16.0),
                  child: Text('Buttons visible on screen', style:  TextStyle(fontSize: 16), textAlign: TextAlign.start,),
                ),

        Center(
          child: NumberPicker(
            itemHeight: 120,
            haptics: true,
            selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 25),
            textStyle: const TextStyle(color: Colors.white70, fontSize: 18),
            zeroPad: true,
            axis: Axis.horizontal,
            value: _currentValue,
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            onChanged: (value) => setState(() {
              _currentValue = value;
              widget.onChangedCallback(value );
            }),
          ),
        ),
      ],
    );
  }
}