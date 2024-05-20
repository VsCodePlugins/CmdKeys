import 'package:vsckeyboard/common/model/command_group_model.dart';
import 'package:vsckeyboard/common/model/command_types.dart';
import 'package:vsckeyboard/common/model/command_model.dart';

Future <List<ModelCommandGroup>> createDefaultCommandGroups({required String keyBaseCommandGroup}) async {
 List<ModelCommandGroup> commandsGroup = [];
  commandsGroup.addAll([
    ModelCommandGroup(
        name: "debugger_commands",
        description: "",
        label: "Debugger Commands",
        onlyType: CommandType.debugVscode),
    ModelCommandGroup(
        name: "vscode_commands",
        description: "",
        label: "Visual Code Commands",
        onlyType: CommandType.vscodeCommand),
    ModelCommandGroup(
        name: "terminal_commands",
        description: "",
        label: "Terminal Commands",
        onlyType:CommandType.terminalCommand)
  ]);


  for (var cmdGroupModel in commandsGroup) {
    await cmdGroupModel.saveAs(keyBaseCommandGroup:keyBaseCommandGroup );
  List<ModelCommand> listModelCmd = cmdGroupModel.onlyType.getDefaultCommands;
  for (ModelCommand  cmdModel in listModelCmd) {
    await cmdModel.saveAs(commandGroupID: cmdGroupModel.id);

  }}
  

  return commandsGroup;
}
