import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

class MenuFab extends StatelessWidget {
  const MenuFab({
    super.key,
    required this.homeController,
    required this.keyboardSettings,
    required this.scaffoldKey,
    required this.panelDashBoard,
  });
  final PanelDashBoard panelDashBoard;
  final HomeController homeController;
  final KeyboardSettingController keyboardSettings;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<ExpandableFabState>();

    return ExpandableFab(
      key: key,
      overlayStyle: ExpandableFabOverlayStyle(
        // color: Colors.black.withOpacity(0.5),
        blur: 5,
      ),
      onOpen: () {
        debugPrint('onOpen');
      },
      afterOpen: () {
        debugPrint('afterOpen');
      },
      onClose: () {
        debugPrint('onClose');
      },
      afterClose: () {
        debugPrint('afterClose');
      },
      children: [
        if (homeController.isHome)
          FloatingActionButton.small(
            // shape: const CircleBorder(),
            heroTag: null,
            child: Icon(MdiIcons.counter),
            onPressed: () {
              final state = key.currentState;
              if (state != null) {
                if (Platform.isAndroid || Platform.isIOS) {
                  Vibration.vibrate(duration: 200);
                }
                keyboardSettings.resetAllCounters();
                state.toggle();
                const SnackBar snackBar = SnackBar(
                  content: Text("Reset all counters in the current keyboard"),
                );
                scaffoldKey.currentState?.showSnackBar(snackBar);
              }
            },
          ),
        if (homeController.isHome)
          FloatingActionButton.small(
            // shape: const CircleBorder(),
            heroTag: null,
            child: !keyboardSettings.lockKeyboard
                ? const Icon(Icons.lock_rounded)
                : const Icon(Icons.lock_open_rounded),
            onPressed: () {
              final state = key.currentState;
              if (state != null) {
                if (Platform.isAndroid || Platform.isIOS) {
                  Vibration.vibrate(duration: 200);
                }
                keyboardSettings
                    .updateLockKeyboard(!keyboardSettings.lockKeyboard);
                state.toggle();
              }
            },
          ),
        FloatingActionButton.small(
          child: (homeController.isHome)
              ? const Icon(Icons.settings)
              : const Icon(Icons.keyboard),
          onPressed: () {
            final state = key.currentState;
            if (state != null) {
              homeController.toggleHomeSettings();
              if (Platform.isAndroid || Platform.isIOS) {
                Vibration.vibrate(duration: 200);
              }
              state.toggle();
            }
          },
        ),
      ],
    );
  }
}
