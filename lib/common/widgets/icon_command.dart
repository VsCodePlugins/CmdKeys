import 'package:flutter/material.dart';
import 'package:flutter_icon_shadow/flutter_icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IconBtn extends StatelessWidget {
  const IconBtn({
    super.key,
    required this.isNotPressed,
    required this.isDarkMode,
    required this.size, required this.color,
     required this.iconName,
  });

  final bool isNotPressed;
  final bool isDarkMode;
  final Size size;
  final Color color;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return IconShadow(
      Icon(MdiIcons.fromString(iconName),
          size: size.width,
          color: isNotPressed
              ? color.withAlpha(100)
              : color),
      shadowColor: isDarkMode ? Colors.black : Colors.white,
      shadowOffset: const Offset(-4, -4),
    );
  }
}
