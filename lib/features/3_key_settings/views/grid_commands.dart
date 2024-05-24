import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vsckeyboard/features/3_key_settings/controllers/grid_controller.dart';

class CommandsGrid extends StatelessWidget {
  const CommandsGrid({
    super.key,
    required this.gridController,
  });

  final GridController gridController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth == 0) {
        return Container();
      }
      return PlutoGrid(
        configuration: const PlutoGridConfiguration.dark(
            style: PlutoGridStyleConfig.dark(
                gridBackgroundColor: Colors.transparent,
                rowColor: Colors.transparent,
                gridBorderColor: Colors.blueGrey,
                gridBorderRadius: BorderRadius.all(Radius.circular(16)),
                gridPopupBorderRadius: BorderRadius.all(Radius.circular(16)),
                borderColor: Colors.blueGrey)),
        columns:gridController.columnCommandsTable,
        rows: gridController.rowCommandsTable,
        onChanged: (PlutoGridOnChangedEvent event) {
          print("object");
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
        },
        // configuration: PlutoConfiguration.dark(),
      );
    });
  }
}
