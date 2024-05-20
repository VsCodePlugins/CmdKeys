  import 'package:vsckeyboard/common/model/command_types.dart';
import 'package:vsckeyboard/common/model/command_model.dart';

List<ModelCommand> createDefaultListDebugger(List<ModelCommand>  commands) {
    commands.addAll([
      ModelCommand(
        index: 0,
        type: CommandType.debugVscode,
        name: 'startDebug',
        command: 'startDebug',
        functionLabel: 'Start',
        description:
            'Start new instance of Debugging, Debugging means to run your code step by step, to find the exact point where you made a programming mistake. You then understand what corrections you need to make in your code and debugging tools often allow you to make temporary changes so you can continue running the program. equivalent to F5',
      ),
      ModelCommand(
        index: 1,
        type: CommandType.debugVscode,
        name: 'continue',
        command: 'continueDebug',
        functionLabel: 'Continue',
        description: '',
      ),
      ModelCommand(
        index: 2,
        type: CommandType.debugVscode,
        name: 'debugStepOver',
        command: 'debugStepOver',
        functionLabel: 'Step Over',
        description:
            'Step Over Debugging is a debugger function that glosses over a line of code, allowing it to execute without stepping into any underlying functions, thereby treating the entire function as a single unit.',
      ),
      ModelCommand(
        index: 3,
        type: CommandType.debugVscode,
        name: 'debugStepInto',
        command: 'debugStepInto',
        functionLabel: 'Step Into',
        description:
            'Step Into command allows you to execute the current activity and move to the next one. If the current activity has child activities, “Step Into” command will move the execution to the first child activity. This command is useful when you want to debug each activity individually and step through the code line by line.',
      ),
      ModelCommand(
        index: 4,
        type: CommandType.debugVscode,
        name: 'debugStepOut',
        command: 'debugStepOut',
        functionLabel: 'Step Out',
        description:
            'Step Out continues running code and suspends execution when the current function returns. The debugger skips through the current function.',
      ),
      ModelCommand(
          index: 5,
          type: CommandType.debugVscode,
          name: 'restart',
          command: 'restartDebug',
          functionLabel: 'Restart',
          description:
              "Restart,If you've made changes to your code while debugging and want to restart debugging with the changes applied, you can use this command to reload the program."),
      ModelCommand(
          index: 6,
          type: CommandType.debugVscode,
          name: 'stop',
          command: 'stopDebug',
          functionLabel: 'Stop',
          description: "Stops the program's execution at the current point.")
    ]);
  return commands;
  }