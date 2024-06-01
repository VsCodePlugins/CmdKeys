import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsckeyboard/common/model/command_group_model.dart';
import 'package:vsckeyboard/common/model/command_types.dart';
import 'package:vsckeyboard/common/model/command_model.dart';

Future<List<ModelCommandGroup>> createDefaultCommandGroups(
    {required String keyBaseCommandGroup,
    required SharedPreferences sharedPreferences}) async {
  List<ModelCommandGroup> commandsGroup = [];
  commandsGroup.addAll([
    ModelCommandGroup(
        name: "debugger_commands",
        description: "",
        label: "Debugger",
        onlyType: CommandType.debugVscode),
    ModelCommandGroup(
        name: "vscode_commands",
        description: "",
        label: "Visual Code",
        onlyType: CommandType.vscodeCommand),
    ModelCommandGroup(
        name: "terminal_commands",
        description: "",
        label: "Terminal",
        onlyType: CommandType.terminalCommand)
  ]);

  for (var cmdGroupModel in commandsGroup) {
    cmdGroupModel.saveAs(
        keyBaseCommandGroup: keyBaseCommandGroup,
        sharedPreferences: sharedPreferences);
    List<ModelCommand> listModelCmd = cmdGroupModel.onlyType.getDefaultCommands;
    for (ModelCommand cmdModel in listModelCmd) {
      await cmdModel.saveAs(
          commandGroupID: cmdGroupModel.id,
          sharedPreferences: sharedPreferences);
    }
  }

  return commandsGroup;
}
