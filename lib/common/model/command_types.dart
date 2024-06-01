import 'package:flutter/material.dart';
import 'package:vsckeyboard/common/class_functions/default_commands.dart';
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

  String get label {
    switch (this) {
      case CommandType.debugVscode:
        return "Debugger";
      case CommandType.vscodeCommand:
        return "Visual Command";
      case CommandType.terminalCommand:
        return "Terminal";
    }
  }

  CommandType get value {
    switch (this) {
      case CommandType.debugVscode:
        return CommandType.debugVscode;
      case CommandType.vscodeCommand:
        return CommandType.vscodeCommand;
      case CommandType.terminalCommand:
        return CommandType.terminalCommand;
    }
  }

  List<String> get keyArgumentList {
    switch (this) {
      case CommandType.debugVscode:
        return ["eventID", "debugCommand"];
      case CommandType.vscodeCommand:
        return ["eventID", "vscodeCommand"];
      case CommandType.terminalCommand:
        return [
          "eventID",
          "terminalName",
          "terminalCommand",
          "commandWithReturn",
        ];
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
        List<ModelCommand> listCmd = createDefaultListVscode([]);
        return listCmd;
      case CommandType.terminalCommand:
        List<ModelCommand> listCmd = createDefaultListTerminalCommand([]);

        return listCmd;
    }
  }

  List<PlutoColumn> getColumns({
    required void Function(int?, BuildContext context)? onRunIt,
    required void Function(int?)? selectRadio,
    required Stream<Map<String, dynamic>> stream,
    required int currentIndex,
    required bool selectMode,
    required double width,
  }) {
    int totalColumnsVisible = 5;
    double widthColumn = width / totalColumnsVisible;

    if (selectMode) {
      totalColumnsVisible = 5;
      widthColumn = width / totalColumnsVisible;
    }

    List<PlutoColumn> baseList = [
      PlutoColumn(
          title: 'Id',
          field: 'id',
          width: widthColumn,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
          hide: true),
      PlutoColumn(
          title: 'Select',
          field: 'select_command',
          type: PlutoColumnType.text(),
          width: widthColumn,
          hide: selectMode ? false : true,
          enableEditingMode: false,
          renderer: (rendererContext) {
            return StreamBuilder<Map<String, dynamic>>(
                stream: stream,
                builder: (context, snapshot) {
                  return Radio(
                      value: rendererContext.rowIdx,
                      groupValue: (snapshot.data?["currentIndex"] as int?) ??
                          currentIndex,
                      onChanged: selectRadio);
                });
          }),
      PlutoColumn(
        title: 'Label',
        field: 'functionLabel',
        enableEditingMode: true,
        width: widthColumn,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          title: 'Name',
          field: 'name',
          width: widthColumn,
          type: PlutoColumnType.text(),
          hide: selectMode ? true : false),
      PlutoColumn(
          title: 'Command',
          field: 'command',
          type: PlutoColumnType.text(),
          width: widthColumn),
      PlutoColumn(
        title: 'Description',
        field: 'description',
        width: widthColumn,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Run',
        field: 'run_command',
        width: widthColumn,
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        renderer: (rendererContext) {
          return Builder(builder: (context) {
            return TextButton(
              onPressed: () {
                if (onRunIt != null) {
                  onRunIt(rendererContext.rowIdx, context);
                }
              },
              child: const Icon(Icons.exit_to_app),
            );
          });
        },
      ),
      PlutoColumn(
          title: 'Created by user',
          field: 'created_by_user',
          width: widthColumn,
          type: PlutoColumnType.text(),
          enableEditingMode: false,
          hide: true),
    ];
    switch (this) {
      case CommandType.debugVscode:
        return baseList;
      case CommandType.vscodeCommand:
        return baseList;
      case CommandType.terminalCommand:
        return baseList;
    }
  }
}
