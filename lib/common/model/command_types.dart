

import 'package:vsckeyboard/common/class_functions/default_commands_debugger.dart';
import 'package:vsckeyboard/common/model/command_model.dart';

enum CommandType { debugVscode, vscodeCommand, terminalCommand}

extension ExtendedCommandType on CommandType {


    String get name{
    switch (this) {
      case CommandType.debugVscode:
          return "debugVscode";
      case CommandType.vscodeCommand:
        return "vscodeCommand";
      case CommandType.terminalCommand:
        return "terminalCommand";
      
    }
  }

    Map<String,dynamic>? get keysArg{
    switch (this) {
      case CommandType.debugVscode:
          return null;
      case CommandType.vscodeCommand:
          return {"VscodeCommand":"",};
      case CommandType.terminalCommand:
          return {"TerminalCommand":"", "terminalName":"", "CommandWithReturn":""};
    }
  }
  
  static CommandType getByName(String name){
     return CommandType.values.where((element) => element.name == name).first;
  }

  List<ModelCommand> get getDefaultCommands{
     switch (this) {
      case CommandType.debugVscode:
          List<ModelCommand> listCmd = createDefaultListDebugger([]);
          return listCmd;
         case CommandType.vscodeCommand:
          return [];
      case CommandType.terminalCommand:
          return [];
     
    }
  }
 
} 