import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vsckeyboard/common/model/command_model.dart';
import 'package:vsckeyboard/features/1_keyboard/controllers/main_controller.dart';
import 'package:vsckeyboard/features/2_keyboard_setting/controllers/keyboard_settings.dart';
import 'package:vsckeyboard/common/class_functions/grid_controller.dart';

class CommandsGrid extends StatelessWidget {
   const CommandsGrid({
    super.key,
    required this.mainController,
    required this.gridController,
    required this.keyboardSettingController,
    required this.widgetFooter,
    required this.widgetHeader,
  });
  final MainController mainController;
  final GridController gridController;
  final KeyboardSettingController keyboardSettingController;
  final Widget widgetFooter;
  final Widget? widgetHeader;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth == 0) {
        return Container();
      }
      return PlutoGrid(
        configuration: const PlutoGridConfiguration.dark(
              style: PlutoGridStyleConfig.dark(
                gridBackgroundColor: Colors.black54,
                rowColor: Colors.transparent,
                menuBackgroundColor: Colors.black87,
                gridBorderColor: Colors.blueGrey,
                activatedColor: Colors.blueGrey,
                gridBorderRadius: BorderRadius.all(Radius.circular(16)),
                gridPopupBorderRadius: BorderRadius.all(Radius.circular(16)),
                borderColor: Colors.blueGrey)),
        columns: gridController.currentGridModel.columnCommandsTable,
        rows: gridController.currentGridModel.rowCommandsTable,
        mode: gridController.gridSelectMode
            ? PlutoGridMode.normal
            : gridController.editMode
                ? PlutoGridMode.normal
                : PlutoGridMode.selectWithOneTap,
        onChanged: (PlutoGridOnChangedEvent event) {

          Map<String, dynamic> data = {event.column.field: event.value};
          String idCmd = event.row.cells["id"]!.value;
          ModelCommand.update(
              sharedPreferences: mainController.preferencesInstance,
              id: idCmd,
              mapModel: data);
        
        
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
          gridController.stateManager = event.stateManager;
        },
        onSelected: (PlutoGridOnSelectedEvent event) {
          gridController.selectCommand(event);
        },
        createHeader: (stateManager) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                (widgetHeader != null) ? widgetHeader : const SizedBox.shrink(),
          );
        },
        // configuration: PlutoConfiguration.dark(),
        createFooter: (stateManager) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: widgetFooter,
          );
        },
      );
    });
  }
}
