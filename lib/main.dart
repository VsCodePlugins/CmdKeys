import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/dashboard.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'features/0_home/views/page_panel.dart';

void main() => runApp(const CustomRemoteKeyboard());

class CustomRemoteKeyboard extends StatelessWidget {
  const CustomRemoteKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const KeyBoard();
  }
}

class KeyBoard extends StatefulWidget {
  const KeyBoard({super.key});

  @override
  _KeyBoardState createState() => _KeyBoardState();
}

class _KeyBoardState extends State<KeyBoard> {
        int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {

      return MultiProvider(
          providers: [
            ChangeNotifierProvider<PanelDashBoard>(
              create: (_) => PanelDashBoard(),
            ),
          ],
          builder: (context, child) {
            final panelDashBoard = context.watch<PanelDashBoard>();

            return ChangeNotifierProvider<KeyboardSettingController>(
                create: (_) => KeyboardSettingController(
                      panelDashBoard.currentKeyBoard.keyBoardName,
                      context,
                    ),
                builder: (context, w) {
                              final keyboardSettings = context.watch<KeyboardSettingController>();

                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    darkTheme: keyboardSettings.darkMode? ThemeData.dark():ThemeData.light(),
                    theme: ThemeData(
                      primarySwatch: Colors.deepPurple,
                    ),
                    title: 'VsCodeRemoteKeyboard',
                    home: Scaffold(
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.miniEndDocked,
                        floatingActionButton: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              panelDashBoard.pageController.animateToPage(panelDashBoard.pageController.page!.toInt() == 1
                                      ? 0
                                      : 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                              if (Platform.isAndroid || Platform.isIOS) {
                                Vibration.vibrate(duration: 200);

                                setState(() {
                                  
                                  currentPage = panelDashBoard.pageController.page!.toInt()== 0?1:0;
                                });
                              }
                            },
                            elevation: 4,
                            mini: false,
                            hoverColor: Colors.deepPurple,
                            foregroundColor:
                                (keyboardSettings.darkMode) ? Colors.black : Colors.white,
                            backgroundColor:
                                Colors.deepPurpleAccent.withOpacity(.5),
                            shape: const CircleBorder(),
                            child: currentPage == 0
                                ? const Icon(Icons.settings)
                                : const Icon(Icons.keyboard),
                          ),
                        ),
                        body: SafeArea(
                            child: PageViewCustom(
                          keyboardSettingCtrl: keyboardSettings,
                          pageController: panelDashBoard.pageController,
                          keyBoardName:
                              panelDashBoard.currentKeyBoard.keyBoardName,
                        ))),
                  );
                });
          });
    });
  }
}