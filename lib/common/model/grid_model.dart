import 'package:pluto_grid/pluto_grid.dart';

class GridModel {
  List<PlutoRow> rowCommandsTable;
  List<PlutoColumn> columnCommandsTable;
  Map<String, dynamic> selectedRow;
  bool gridSelectMode;
  bool editMode;
  int currentIndex;
  GridModel(
      {required this.rowCommandsTable,
      required this.columnCommandsTable,
      required this.selectedRow,
      required this.gridSelectMode,
      required this.editMode,
      required this.currentIndex});
}
