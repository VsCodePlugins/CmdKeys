import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String? text;
  final bool autofocus;
  final Color backgroundColor;
  final Function()? functionOnPress;
  final double height;
  final double? width;
  final Widget ?childWidget;

  const StandardButton({
    super.key,
    required this.text,
    this.functionOnPress,
    this.autofocus = false,
    required this.backgroundColor,
    this.height = 40,
    this.width,
     this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      autofocus: false,
      onPressed: functionOnPress,
      onLongPress: () {},
      style: ButtonStyle(
        side: WidgetStateProperty.all(
            const BorderSide(color: Colors.transparent, width: 2)),
        backgroundColor:
            WidgetStatePropertyAll<Color>(Colors.blueAccent.withOpacity(0.1)),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height: height,
            width: width,
            child: Center(
                child: (text != null)
                    ? Text(
                        text!,
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.blue),
                      )
                    : childWidget)),
      ),
    );
  }
}
