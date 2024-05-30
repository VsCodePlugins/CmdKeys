import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

class JsonWidget extends StatelessWidget {
  final Map<String, dynamic>? dataMap;

  const JsonWidget({
    super.key,
    required this.dataMap,
  });

  @override
  Widget build(BuildContext context) {
    return (dataMap == null)
        ? const SizedBox.shrink()
        : JsonView.map(
          key: key,
            dataMap!,
            theme: const JsonViewTheme(
              
              viewType: JsonViewType.collapsible,
              keyStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              doubleStyle: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
              intStyle: TextStyle(
                color: Colors.orange,
                fontSize: 16,
              ),
              stringStyle: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
              ),
              boolStyle: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
              closeIcon: Icon(
                Icons.close,
                color: Colors.blueAccent,
                size: 20,
              ),
              openIcon: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
              separator: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.arrow_right_alt_outlined,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }
}
