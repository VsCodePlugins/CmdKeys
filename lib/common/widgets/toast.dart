import 'package:flutter/material.dart';

class MessageToast extends StatelessWidget {
  final String message;
  final Icon iconToast;
  final bool isDarkMode;
  const MessageToast({
    super.key,
    required this.message, required this.isDarkMode, required this.iconToast,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width ,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: (isDarkMode)? Colors.black.withOpacity(0.8): Colors.white,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: iconToast,
            ),
            SizedBox(
              width: width -150,
              child: Text(
                message,
                style:  TextStyle(
                  color:  isDarkMode? Colors.blueAccent:Colors.black,
                  fontSize: 17,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}