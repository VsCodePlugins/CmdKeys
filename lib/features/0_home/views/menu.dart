import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

class MenuFab extends StatefulWidget {
  const MenuFab({
    super.key,
    required this.panelDashBoard,
    required this.keyboardSettings,
    required this.scaffoldKey,
  });

  final PanelDashBoard panelDashBoard;
  final KeyboardSettingController keyboardSettings;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

  @override
  State<MenuFab> createState() => _MenuFabState();
}

class _MenuFabState extends State<MenuFab> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    widget.panelDashBoard.pageController.addListener(() {
      _currentPage = widget.panelDashBoard.pageController.page!.toInt();
    });
  }

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
        if (_currentPage == 1)
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
                widget.panelDashBoard.resetAllCounters();
                state.toggle();
                const SnackBar snackBar = SnackBar(
                  content: Text("Reset all counters in the current keyboard"),
                );
                widget.scaffoldKey.currentState?.showSnackBar(snackBar);
              }
            },
          ),
        if (_currentPage == 1)
          FloatingActionButton.small(
            // shape: const CircleBorder(),
            heroTag: null,
            child: !widget.keyboardSettings.lockKeyboard
                ? const Icon(Icons.lock_rounded)
                : const Icon(Icons.lock_open_rounded),
            onPressed: () {
              final state = key.currentState;
              if (state != null) {
                if (Platform.isAndroid || Platform.isIOS) {
                  Vibration.vibrate(duration: 200);
                }
                widget.keyboardSettings
                    .updateLockKeyboard(!widget.keyboardSettings.lockKeyboard);
                state.toggle();
              }
            },
          ),
        FloatingActionButton.small(
          // shape: const CircleBorder(),
          child: _currentPage == 1
              ? const Icon(Icons.settings)
              : const Icon(Icons.keyboard),
          onPressed: () {
            final state = key.currentState;
            if (state != null) {
              widget.panelDashBoard.pageController.animateToPage(
                  _currentPage == 1 ? 2 : 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
              if (Platform.isAndroid || Platform.isIOS) {
                Vibration.vibrate(duration: 200);
              }
              state.toggle();
            }
            WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                  _currentPage =
                      widget.panelDashBoard.pageController.page!.toInt();
                }));
          },
        ),
      ],
    );
  }
}
