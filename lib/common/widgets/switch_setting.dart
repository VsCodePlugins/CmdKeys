import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SwitchSetting extends StatefulWidget {

  
  SwitchSetting({
    super.key,
    required this.isDarkMode,
    required this.state,
    required this.functionOnChange,
    required this.label,
  });
  
  final bool isDarkMode ;
  Function(bool) functionOnChange;
  final String label;
  bool state; 
  @override
  State<SwitchSetting> createState() => _SwitchSettingState();
}

class _SwitchSettingState extends State<SwitchSetting> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top:0, bottom: 16),
      child: Row(
        children: [
          AnimatedToggleSwitch<int>.size(
              current: widget.state ? 1 : 0,
              height: 56,
              values: const [0, 1],
    
              style: ToggleStyle(
                  indicatorColor: Colors.grey.withOpacity(.5),
                  borderColor: widget.isDarkMode? Colors.white30:Colors.black45,
                  
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              onChanged: (i) => setState(
                    () {
                      bool showExceptions = i == 0 ? false : true;
                      widget.functionOnChange(showExceptions);
                    },
                  ),
              iconList:  [
                const Icon(Icons.close),
                Icon(
                  Icons.check,
                  color: widget.isDarkMode? Colors.blueAccent:Colors.blue,
                )
              ]),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.label,
              style: (widget.isDarkMode)?TextStyle(
                  fontSize: 16,
                  color: !widget.state
                      ? Colors.white54
                      : Colors.white):
                      TextStyle(
                          fontSize: 16,
                          color: widget.state
                             ? Colors.black
                              : Colors.black38),
            ),
          )),
        ],
      ),
    );
  }
}
