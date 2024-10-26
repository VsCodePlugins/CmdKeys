import 'package:fkeys/common/model/command_types.dart';
import 'package:fkeys/common/model/command_model.dart';

List<ModelCommand> createDefaultListDebugger(List<ModelCommand> commands) {
  commands.addAll([
    ModelCommand(
        index: 0,
        type: CommandType.debugVscode,
        name: 'startDebug',
        mapCommand: {"debugCommand": 'start'},
        functionLabel: 'Start',
        description:
            'This command is equivalent to "workbench.action.debug.start".\nStart new instance of Debugging, Debugging means to run your code step by step, to find the exact point where you made a programming mistake.\nYou then understand what corrections you need to make in your code and debugging tools often allow you to make temporary changes so you can continue running the program. equivalent to F5',
        deletable: false),
    ModelCommand(
        index: 1,
        type: CommandType.debugVscode,
        name: 'continue',
        mapCommand: {"debugCommand": 'continue'},
        functionLabel: 'Continue',
        description:
            'This command is equivalent to "workbench.action.debug.continue".',
        deletable: false),
    ModelCommand(
        index: 2,
        type: CommandType.debugVscode,
        name: 'debugStepOver',
        mapCommand: {"debugCommand": 'stepOver'},
        functionLabel: 'Step Over',
        description:
            'This command is equivalent to "workbench.action.debug.stepOver".\nStep Over Debugging is a debugger function that glosses over a line of code.\nAllowing it to execute without stepping into any underlying functions, thereby treating the entire function as a single unit.',
        deletable: false),
    ModelCommand(
        index: 3,
        type: CommandType.debugVscode,
        name: 'debugStepInto',
        mapCommand: {"debugCommand": 'stepInto'},
        functionLabel: 'Step Into',
        description:
            'This command is equivalent to "workbench.action.debug.stepInto".\nStep Into command allows you to execute the current activity and move to the next one.\nIf the current activity has child activities, “Step Into” command will move the execution to the first child activity.\nThis command is useful when you want to debug each activity individually and step through the code line by line.',
        deletable: false),
    ModelCommand(
        index: 4,
        type: CommandType.debugVscode,
        name: 'debugStepOut',
        mapCommand: {"debugCommand": 'stepOut'},
        functionLabel: 'Step Out',
        description:
            'This command is equivalent to "workbench.action.debug.stepOut".\nStep Out continues running code and suspends execution when the current function returns.\nThe debugger skips through the current function.',
        deletable: false),
    ModelCommand(
        index: 5,
        type: CommandType.debugVscode,
        name: 'restart',
        mapCommand: {"debugCommand": 'restart'},
        functionLabel: 'Restart',
        description:
            "This command is equivalent to 'workbench.action.debug.restart'.\nRestart, If you've made changes to your code while debugging and want to restart debugging with the changes applied.",
        deletable: false),

    ModelCommand(
        index: 6,
        type: CommandType.debugVscode,
        name: 'stop',
        mapCommand: {"debugCommand": 'stop'},
        functionLabel: 'Stop',
        description:
            "This command is equivalent to 'workbench.action.debug.stop'.\nStops the program's execution at the current point.",
        deletable: false),

    ModelCommand(
        index: 7,
        type: CommandType.debugVscode,
        name: 'configure',
        mapCommand: {"debugCommand": 'configure'},
        functionLabel: 'Debugging Configuration',
        description:
            "This command is equivalent to 'workbench.action.debug.configure'\nOpens debugging configuration.",
        deletable: false),

   
  ]);
  return commands;
}



List<ModelCommand> createDefaultListVscode(List<ModelCommand> commands) {
  commands.addAll([
    ModelCommand(
        index: 0,
        type: CommandType.vscodeCommand,
        name: 'newWindow',
        mapCommand: {"vscodeCommand": 'vscode.newWindow'},
        functionLabel: 'Open new Window',
        description:
            'This command is equivalent to "vscode.newWindow".\n Opens an new window depending on the newWindow ',
        deletable: false)
   
  ]);
  return commands;
}


List<ModelCommand> createDefaultListTerminalCommand(List<ModelCommand> commands) {
  commands.addAll([
    ModelCommand(
        index: 0,
        type: CommandType.vscodeCommand,
        name: 'linux_ls_a_in_current_path',
        mapCommand: {"commandWithReturn":"ls -a"},
        functionLabel: 'list_file_in_path',
        description:'get the list of files in current directory',
        deletable: false),
         ModelCommand(
        index: 1,
        type: CommandType.vscodeCommand,
        name: '',
        mapCommand: {"terminalName": "Git Status",  "terminalCommand":"git status"},
        functionLabel: 'git_status',
        description:'Show in terminal git status',
        deletable: false)
   

   
  ]);
  return commands;
}