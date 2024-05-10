import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/0_home/views/menu.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'features/0_home/views/page_panel.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

void main() async {
  // ignore: unused_local_variable
  // SharedPreferences  sharedPreferences  = await SharedPreferences.getInstance();
  //sharedPreferences.clear();
  return runApp(const CustomRemoteKeyboard());
}

class CustomRemoteKeyboard extends StatelessWidget {
  const CustomRemoteKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const KeyBoard();
  }
}
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class KeyBoard extends StatelessWidget {
  const KeyBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ChangeNotifierProvider<PanelDashBoard>(
          create: (_) => PanelDashBoard(),
          builder: (context, child) {
            final panelDashBoard = context.watch<PanelDashBoard>();

            return MultiProvider(
                providers: [
                  ChangeNotifierProvider<HomeController>(
                    create: (homeController) => HomeController(),
                  ),
                  ChangeNotifierProvider<KeyboardSettingController>(
                    create: (_) => KeyboardSettingController(
                        panelDashBoard, context),
                  ),
                ],
                builder: (context, w) {
                  final homeController = context.watch<HomeController>();

                  final keyboardSettings =
                      context.watch<KeyboardSettingController>();
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    darkTheme: keyboardSettings.darkMode
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    theme: ThemeData(
                        primarySwatch: Colors.deepPurple,
                        colorScheme: keyboardSettings.darkMode
                            ? const ColorScheme.dark()
                            : const ColorScheme.light()),
                    title: 'VsCodeRemoteKeyboard',
                    home: Scaffold(
                        key: scaffoldKey,
                        floatingActionButtonLocation: ExpandableFab.location,
                        floatingActionButton: MenuFab(
                          homeController: homeController,
                          keyboardSettings: keyboardSettings,
                          scaffoldKey: scaffoldKey,
                          panelDashBoard: panelDashBoard,
                        ),
                        body: SafeArea(
                            child: PageViewCustom(
                          keyboardSettingCtrl: keyboardSettings,
                          pageController: homeController.pageController,
                          keyBoardName:
                              panelDashBoard.currentKeyBoard.keyBoardName,
                          homeController: homeController,
                        ))),
                  );
                });
          });
    });
  }
}
