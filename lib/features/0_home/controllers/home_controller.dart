import 'package:flutter/material.dart';
import 'package:vsckeyboard/features/0_home/%20models/pages.dart';
import 'package:vsckeyboard/features/1_keyboard/%20models/button_properties.dart';

class HomeController with ChangeNotifier {
  final pageController = PageController(initialPage: PagesApp.keyboard.numberPage);
  bool isHome = true;
  PagesApp currentPage = PagesApp.keyboard;


  changePage(PagesApp page) async {
    await pageController.animateToPage(page.numberPage,
        duration: const Duration(milliseconds: 500), curve: Easing.standard);
    if (page == PagesApp.keyboard) {
      isHome = true;
    } else {
      isHome = false;
    }
    currentPage = page;
    notifyListeners();
  }

  toggleHomeSettings() {
    if (currentPage == PagesApp.keyboard) {
      changePage(PagesApp.settingsKeyboard);
    } else {
      changePage(PagesApp.keyboard);
    }

  }
}
