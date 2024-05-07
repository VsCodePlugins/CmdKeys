
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderSetting extends StatefulWidget {
  final double size;
  final Function(double) onChange;
  final bool isDarkMode ;

  const SliderSetting({
    super.key, required this.size, required this.onChange, required this.isDarkMode,
  });

  @override
  State<SliderSetting> createState() => _SliderSettingState();
}

class _SliderSettingState extends State<SliderSetting> {
  late double iconSize;

  @override
  void initState() {
    super.initState();
    iconSize = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text("Icons size",
                style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
          ),
          Center(
              child: Icon(
            Icons.house_rounded,
            size: iconSize,
            color: widget.isDarkMode?  Colors.white:Colors.black54,
          )),
          SfSlider(
            min: 10,
            max: 100.0,
            value: iconSize,
            showTicks: true,
            showLabels: true,
            activeColor: widget.isDarkMode?  Colors.white:Colors.grey[600],
            enableTooltip: true,
            minorTicksPerInterval: 1,
            onChanged: (dynamic value) {
              setState(() {
                iconSize = value;
                widget.onChange(iconSize);
              });
            },
          ),
          
          // Padding(
          //   padding: const EdgeInsets.all(18.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //     },
          //     style: ButtonStyle(
                
          //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
          //           side: const BorderSide(width: 2, color: Colors.grey),
          //           borderRadius: BorderRadius.circular(12))),
          //     ),
          //     child:  Padding(
          //       padding: const EdgeInsets.all(18.0),
          //       child: SizedBox(child: Center(child: Text('Save icon size', style: TextStyle(color:  widget.keyboardSettingCtrl.darkMode?  Colors.white:Colors.black87),))),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
