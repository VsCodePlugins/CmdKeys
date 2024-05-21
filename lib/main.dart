import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/features/0_home/controllers/home_controller.dart';
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
                panelDashBoard.mainStreamStateCtrl.sink
                    .add({"isMenuOpen": false});

                final keyboardSettings =
                    context.watch<KeyboardSettingController>();
                return MaterialApp(
                    color: const Color.fromRGBO(33, 150, 243, 1),
                    themeMode: ThemeMode.dark,
                    debugShowCheckedModeBanner: false,
                    darkTheme: keyboardSettings.darkMode
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    theme: ThemeData(
                        inputDecorationTheme: InputDecorationTheme(
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              )),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          )),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(
                              color: keyboardSettings.darkMode
                                  ? Colors.white
                                  : Colors.black),
                          prefixStyle: TextStyle(
                              color: keyboardSettings.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                          hintStyle: TextStyle(
                              color: keyboardSettings.darkMode
                                  ? const Color.fromARGB(255, 66, 66, 66)
                                  : const Color.fromARGB(255, 201, 201, 201)),
                        ),
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: Colors.blue,
                          selectionColor: Colors.blue[300],
                          selectionHandleColor: Colors.blueAccent,
                        ),
                        buttonTheme: const ButtonThemeData(
                          buttonColor: Colors.blueAccent,
                        ),
                        primaryColorDark: Colors.blueAccent,
                        secondaryHeaderColor: Colors.blue,
                        primaryColor: Colors.blueAccent,
                        highlightColor: Colors.blueAccent,
                        primarySwatch: Colors.blue,
                        hintColor: Colors.blueAccent,
                        colorScheme: keyboardSettings.darkMode
                            ? const ColorScheme.dark()
                            : const ColorScheme.light()),
                    title: 'VsCode Keyboard',
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
