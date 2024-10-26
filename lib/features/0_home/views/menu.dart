import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:fkeys/features/0_home/%20models/pages.dart';
import 'package:fkeys/features/0_home/controllers/home_controller.dart';
import 'package:fkeys/features/0_home/controllers/menu_controller.dart';
import 'package:fkeys/features/1_keyboard/controllers/main_controller.dart';
import 'package:fkeys/features/2_keyboard_setting/controllers/keyboard_settings_controller.dart';
import 'package:fkeys/features/2_keyboard_setting/views/page_keyboard_settings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MenuFunctions extends StatelessWidget {
  const MenuFunctions({
    super.key,
    required this.homeController,
    required this.keyboardSettings,
    required this.scaffoldKey,
    required this.mainController,
    required this.keyHomeMenu,
  });
  final MainController mainController;
  final HomeController homeController;
  final KeyboardSettingController keyboardSettings;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final GlobalKey<ExpandableFabState> keyHomeMenu;

  @override
  Widget build(BuildContext context) {
    bool isMobile = false;
    return OrientationBuilder(builder: (context, orientation) {
      double? width;
      double? height;

      if (orientation == Orientation.landscape) {
        width = MediaQuery.of(context).size.width - 66;
      } else {
        height = MediaQuery.of(context).size.height - 66;
      }

      if (!kIsWeb) {
        if (Platform.isAndroid || Platform.isIOS) {
          isMobile = true;
        }
      }

      if (kIsWeb && width != null && width > 1000) {
        width = MediaQuery.of(context).size.width / 2;
      }

      return Stack(
        children: [
          ChangeNotifierProvider<HomeMenuController>(
              create: (homeController) => HomeMenuController(
                  mainSteamState: mainController.mainStreamState),
              builder: (context, w) {
                final homeMenuController = context.watch<HomeMenuController>();
                return (homeMenuController.isMenuOpen)
                    ? Container(
                        color: keyboardSettings.darkMode
                            ? Colors.black54
                            : Colors.white54)
                    : const SizedBox.shrink();
              }),
          OverLapMenu(
            mainController: mainController,
            homeController: homeController,
            keyboardSettings: keyboardSettings,
            isMobile: isMobile,
            orientation: orientation,
            overlapKey: keyHomeMenu,
          ),
          Padding(
            padding: kIsWeb? const EdgeInsets.only(right:66): const EdgeInsets.all(0),
            child: Align(
              alignment : kIsWeb?  Alignment.bottomRight: Alignment.bottomLeft ,
              child: SizedBox(
                width: width,
                height: height,
                child: Settings(
                  mainController: mainController,
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}

class OverLapMenu extends StatelessWidget {
  const OverLapMenu(
      {super.key,
      required this.mainController,
      required this.homeController,
      required this.keyboardSettings,
      required this.isMobile,
      required this.orientation,
      required this.overlapKey});

  final MainController mainController;
  final HomeController homeController;
  final KeyboardSettingController keyboardSettings;
  final bool isMobile;
  final Orientation orientation;
  final GlobalKey<ExpandableFabState> overlapKey;
  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: overlapKey,
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
      type: orientation == Orientation.landscape
          ? ExpandableFabType.up
          : ExpandableFabType.side,
      overlayStyle: ExpandableFabOverlayStyle(
        // color: Colors.black.withOpacity(0.5),
        blur: 8,
      ),
      onOpen: () {
        FocusManager.instance.primaryFocus?.unfocus();
        debugPrint('onOpen');
      },
      afterOpen: () {
        debugPrint('afterOpen');
        mainController.mainStreamStateCtrl.sink.add({"isMenuOpen": true});
      },
      onClose: () {
        debugPrint('onClose');
        mainController.mainStreamStateCtrl.sink.add({"isMenuOpen": false});
        mainController.updateMainInterface();
      },
      afterClose: () {
        debugPrint('afterClose');
      },
      children: [
        if (homeController.isHome)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton.small(
              // shape: const CircleBorder(),
              backgroundColor: Colors.black54,
              foregroundColor: Colors.blueAccent,
              child: Icon(MdiIcons.plusBox),
              onPressed: () {
                final state = overlapKey.currentState;

                if (state != null) {
                  keyboardSettings.currentBtnProperty =
                      mainController.addNewBtnProperty(
                          sizeIcon: keyboardSettings.sizeIcon,
                          groupName:
                              mainController.currentKeyBoard.keyBoardName);
                  state.toggle();

                  homeController.changePage(PagesApp.settingsKey);
                }
              },
            ),
          ),
        if (homeController.isHome)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton.small(
              backgroundColor: Colors.black54,
              foregroundColor: Colors.blueAccent,
              // shape: const CircleBorder(),
              heroTag: null,
              child: !keyboardSettings.lockKeyboard
                  ? const Icon(Icons.edit)
                  : const Icon(Icons.edit_note_sharp),
              onPressed: () {
                final state = overlapKey.currentState;
                if (state != null) {
                  if (isMobile) {
                    Vibration.vibrate(duration: 200);
                  }
                  keyboardSettings
                      .updateLockKeyboard(!keyboardSettings.lockKeyboard);
                  state.toggle();
                }
              },
            ),
          ),
        if (homeController.currentPage == PagesApp.settingsKey)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton.small(
              backgroundColor: Colors.black54,
              foregroundColor: Colors.blueAccent,
              child: SvgPicture.asset(
                width: 21,
                'images/vscode_keyboard.svg',
                color: Colors.blueAccent,
              ),
              onPressed: () {
                final state = overlapKey.currentState;
                if (state != null) {
                  homeController.changePage(PagesApp.allCommands);
                  if (isMobile) {
                    Vibration.vibrate(duration: 200);
                  }
                  state.toggle();
                }
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FloatingActionButton.small(
            backgroundColor: Colors.black54,
            foregroundColor: Colors.blueAccent,
            child: (homeController.isHome)
                ? SvgPicture.asset(
                    width: 21,
                    'images/vscode_keyboard.svg',
                    color: Colors.blueAccent,
                  )
                : const Icon(Icons.grid_view_rounded),
            onPressed: () {
              final state = overlapKey.currentState;
              if (state != null) {
                homeController.toggleHomeSettings();
                if (isMobile) {
                  Vibration.vibrate(duration: 200);
                }
                state.toggle();
              }
            },
          ),
        ),
      ],
    );
  }
}

class Settings extends StatelessWidget {
  final MainController mainController;
  const Settings({
    super.key,
    required this.mainController,
  });
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeMenuController>(
        create: (homeController) =>
            HomeMenuController(mainSteamState: mainController.mainStreamState),
        builder: (context, w) {
          final homeMenuController = context.watch<HomeMenuController>();
          return (homeMenuController.isMenuOpen)
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 30),
                          child: TextButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                    Colors.black54),
                              ),
                              onPressed: () {
                                homeMenuController.openUrl();
                              },
                              child: SizedBox(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      width: 25,
                                      'images/vscode_keyboard.svg',
                                      color: Colors.blueAccent,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 8.0, right: 8),
                                      child: Text(
                                        "Settings",
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                        overflow: TextOverflow.fade,
                                        
                                      ),
                                    )
                                  ],
                                ),
                              ))),
                      FocusScope(
                          child: KeyboardSettings(
                        keyBoardName:
                            mainController.currentKeyBoard.keyBoardName,
                        notify: homeMenuController.updateInterface,
                      )),
                    ],
                  ),
                )
              : const SizedBox();
        });
  }
}
