import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/0_home/controllers/menu_controller.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';

class MenuFunctions extends StatelessWidget {
  const MenuFunctions({
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

    return Stack(
      children: [
        ExpandableFab(
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu_rounded),
            fabSize: ExpandableFabSize.regular,
            foregroundColor: Colors.blueAccent,
            backgroundColor: Colors.black54,
          ),
          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.close_rounded),
            fabSize: ExpandableFabSize.regular,
            foregroundColor: Colors.blueAccent,
            backgroundColor: Colors.black54,
          ),
          key: key,
          type: ExpandableFabType.fan ,
          overlayStyle: ExpandableFabOverlayStyle(
            // color: Colors.black.withOpacity(0.5),
            blur: 6,
          ),
          onOpen: () {
            FocusManager.instance.primaryFocus?.unfocus();
            debugPrint('onOpen');
          },
          afterOpen: () {
            debugPrint('afterOpen');
            panelDashBoard.mainStreamStateCtrl.sink.add({"isMenuOpen": true});
          },
          onClose: () {
            debugPrint('onClose');
            panelDashBoard.mainStreamStateCtrl.sink.add({"isMenuOpen": false});
          },
          afterClose: () {
            debugPrint('afterClose');
          },
          children: [
            if (homeController.isHome)
              FloatingActionButton.small(
                // shape: const CircleBorder(),
                backgroundColor: Colors.black54,
                foregroundColor: Colors.blueAccent,
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
                      content:
                          Text("Reset all counters in the current keyboard"),
                    );
                    scaffoldKey.currentState?.showSnackBar(snackBar);
                  }
                },
              ),
            if (homeController.isHome)
              FloatingActionButton.small(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.blueAccent,
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
              backgroundColor: Colors.black54,
              foregroundColor: Colors.blueAccent,
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
        ),
        SubMenu(
          panelDashBoard: panelDashBoard,
        ),

      ],
    );
  }
}

class SubMenu extends StatelessWidget {
  final PanelDashBoard panelDashBoard;
  const SubMenu({
    super.key,
    required this.panelDashBoard,
  });
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeMenuController>(
        create: (homeController) =>
            HomeMenuController(mainSteamState: panelDashBoard.mainStreamState),
        builder: (context, w) {
          const String assetName = 'images/vscode_keyboard.svg';
          final homeMenuController = context.watch<HomeMenuController>();
          return (homeMenuController.isMenuOpen)
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 30),
                  child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.black54),
                      ),
                      onPressed: () {
                        homeMenuController.openUrl();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            width: 25,
                            assetName,
                            color: Colors.blueAccent,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8),
                            child: Text(
                              "www.vscodekeyboard.com",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )))
              : const SizedBox();
        });
  }
}
