

enum PagesApp { settingsKey, keyboard, settingsKeyboard }

extension ExtensionItemContact on PagesApp {

    int get numberPage {
    switch (this) {
    
      case PagesApp.settingsKey:
          return 0;
      case PagesApp.keyboard:
        return 1;
      case PagesApp.settingsKeyboard:
        return 2;
    }
  }

    String get nameKey {
    switch (this) {
      case PagesApp.settingsKey:
          return "settingsKey";
      case PagesApp.keyboard:
        return "keyboard";
      case PagesApp.settingsKeyboard:
        return "settingsKeyboard";
    }
  }

} 