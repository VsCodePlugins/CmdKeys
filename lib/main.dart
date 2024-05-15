import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
import 'package:vsckeyboard/features/0_home/controllers/menu_controller.dart';
import 'package:vsckeyboard/features/0_home/views/menu.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'features/0_home/views/page_panel.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//await sharedPreferences.clear();
  WakelockPlus.enable();
  return runApp(const VscodeKeyboard());
}

class VscodeKeyboard extends StatelessWidget {
  const VscodeKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Start();
  }
}

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class Start extends StatelessWidget {
  const Start({super.key});
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
                  create: (_) =>
                      KeyboardSettingController(panelDashBoard, context),
                ),
              ],
              builder: (context, w) {
                final homeController = context.watch<HomeController>();
                  panelDashBoard.mainStreamStateCtrl.sink.add({"isMenuOpen": false});

                final keyboardSettings =
                    context.watch<KeyboardSettingController>();
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    darkTheme: keyboardSettings.darkMode
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    theme: ThemeData(
                        primaryColorDark: Colors.blueAccent,
                        secondaryHeaderColor: Colors.blue,
                        primaryColor: Colors.blueAccent,
                        primarySwatch: Colors.blue,
                        colorScheme: keyboardSettings.darkMode
                            ? const ColorScheme.dark()
                            : const ColorScheme.light()),
                    title: 'VsCodeRemoteKeyboard',
                    home: Scaffold(
                        key: scaffoldKey,
                        floatingActionButtonLocation: ExpandableFab.location,
                        floatingActionButton: MenuFunctions(
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
                          panelDashBoard: panelDashBoard,
                        ))));
              },
            );
          });
    });
  }
}
