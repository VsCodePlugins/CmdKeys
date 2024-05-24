import 'package:flutter/material.dart';
import 'package:vsckeyboard/common/class_functions/default_commands_debugger.dart';
import 'package:vsckeyboard/common/model/command_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

enum CommandType { debugVscode, vscodeCommand, terminalCommand }

extension ExtendedCommandType on CommandType {
  String get name {
    switch (this) {
      case CommandType.debugVscode:
        return "debugVscode";
      case CommandType.vscodeCommand:
        return "vscodeCommand";
      case CommandType.terminalCommand:
        return "terminalCommand";
    }
  }

  Map<String, dynamic>? get keysArg {
    switch (this) {
      case CommandType.debugVscode:
        return null;
      case CommandType.vscodeCommand:
        return {
          "VscodeCommand": "",
        };
      case CommandType.terminalCommand:
        return {
          "TerminalCommand": "",
          "terminalName": "",
          "CommandWithReturn": ""
        };
    }
  }

  static CommandType getByName(String name) {
    return CommandType.values.where((element) => element.name == name).first;
  }

  List<ModelCommand> get getDefaultCommands {
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

  List<PlutoColumn> getColumns(
      {required void Function(int?)? onRunIt,
      required void Function(int?)? selectRadio,
      required Stream<Map<String, dynamic>> stream,
      required int currentIndex,
      }) {
    switch (this) {
      case CommandType.debugVscode:
        List<PlutoColumn> listPC = [
          PlutoColumn(
              title: 'Select',
              field: 'select_command',
              type: PlutoColumnType.text(),
              width: 100,
              enableEditingMode: false,
              renderer: (rendererContext) {
                return StreamBuilder<Map<String, dynamic>>(
                    stream: stream,
                    builder: (context, snapshot) {
                      return Radio(
                          value: rendererContext.rowIdx,
                          groupValue: (snapshot.data?["currentIndex"] as int?) ?? currentIndex,
                          onChanged: selectRadio);
                    });
              }),
          PlutoColumn(
            title: 'Label',
            field: 'label',
            width: 200,
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Name',
            field: 'name',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Command',
            field: 'command',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Description',
            field: 'description',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Run',
            field: 'run_command',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            renderer: (rendererContext) {
              return TextButton(
                onPressed: () {
                  if (onRunIt != null) {
                    onRunIt(rendererContext.rowIdx);
                  }
                },
                child: const Text("Run"),
              );
            },
          ),
        ];
        return listPC;
      case CommandType.vscodeCommand:
        return [
          PlutoColumn(
              title: 'Select',
              field: 'select_command',
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              renderer: (rendererContext) {
                return Radio(
                    value: rendererContext.rowIdx,
                    groupValue: 1,
                    onChanged: (selected) {});
              }),
          PlutoColumn(
            title: 'Name',
            field: 'name',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Command',
            field: 'command',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Description',
            field: 'description',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Run',
            field: 'run_command',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            renderer: (rendererContext) {
              return TextButton(
                onPressed: () {
                  if (onRunIt != null) {
                    onRunIt(rendererContext.rowIdx);
                  }
                },
                child: const Text("Run"),
              );
            },
          ),
        ];
      case CommandType.terminalCommand:
        return [
          PlutoColumn(
              title: 'Select',
              field: 'select_command',
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              renderer: (rendererContext) {
                return Radio(
                    value: rendererContext.rowIdx,
                    groupValue: 1,
                    onChanged: (selected) {});
              }),
          PlutoColumn(
            title: 'Name',
            field: 'name',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
              title: 'With Return',
              field: 'with_return',
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              enableRowChecked: true),
          PlutoColumn(
            title: 'Format',
            field: 'format',
            type: PlutoColumnType.select(["String", "Json"]),
          ),
          PlutoColumn(
            title: 'Command',
            field: 'command',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Description',
            field: 'description',
            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            title: 'Run',
            field: 'run_command',
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            renderer: (rendererContext) {
              return TextButton(
                onPressed: () {
                  if (onRunIt != null) {
                    onRunIt(rendererContext.rowIdx);
                  }
                },
                child: const Text("Run"),
              );
            },
          ),
        ];
    }
  }
}
