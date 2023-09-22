import 'dart:ffi';

import 'package:dgtesting/Database/myDB.dart';
import 'package:dgtesting/Screens/employeeDetails_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:drift/drift.dart' as drift;

class DataGridScreen extends StatefulWidget {
  const DataGridScreen({super.key});

  @override
  State<DataGridScreen> createState() => _DataGridScreenState();
}

class _DataGridScreenState extends State<DataGridScreen> {
  late EmployeeDB _employeeDB;
  EmployeeDataSource? _employeeDataSource;

  List<EmployeeCompanion> _employees = <EmployeeCompanion>[];

  @override
  void initState() {
    initDb();
    super.initState();
  }

  void initDb() async {
    _employeeDB = Provider.of<EmployeeDB>(context, listen: false);
    getEmployeeData(); // Wait for getEmployeeData to complete
  }

  void getEmployeeData() async {
    try {
      final theEmployees = await _employeeDB.select(_employeeDB.employee).get();
      _employees = theEmployees.map((data) => data.toCompanion(true)).toList();
      _employeeDataSource = EmployeeDataSource(employees: _employees);
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting results: $e');
      }
    }
  }

  void addNewEmployee() async {
    //ADD NEW RECORD TO DATABASE
    const recordToAdd = EmployeeCompanion(
      name: drift.Value('NEW PERSON'),
      designation: drift.Value('NEW PERSON DESIGNATION'),
      salary: drift.Value(52103),
    );
    await _employeeDB.into(_employeeDB.employee).insert(recordToAdd);

    final theEmployees = await _employeeDB.select(_employeeDB.employee).get();
    _employees = theEmployees.map((data) => data.toCompanion(true)).toList();
    _employeeDataSource?.buildDataGridRows(_employees);
    _employeeDataSource?.updateDataGridSource();
  }

  void deleteEmployee(int rowIndex) async {
    try {
      if (_employeeDataSource != null &&
          rowIndex >= 0 &&
          rowIndex < _employeeDataSource!.dataGridRows.length) {
        final dataGridRow = _employeeDataSource!.dataGridRows[rowIndex];
        final dbID = dataGridRow
            .getCells()
            .firstWhere((cell) => cell.columnName == 'id')
            .value;

        // Find the record with the matching 'dbID' in the database
        final employeeToDelete = await _employeeDB.getSelectedEmployee(dbID);

        if (employeeToDelete != null) {
          // Delete the record from the database
          await _employeeDB
              .delete(_employeeDB.employee)
              .delete(employeeToDelete);

          // Show a message or perform any other necessary action
          print('Record with ID $dbID deleted successfully.');
        } else {
          print('Record with ID $dbID not found.');
        }
      }
    } catch (e) {
      // Handle any errors that may occur during the deletion process
      print('Error deleting record: $e');
    }
    _employeeDataSource?.dataGridRows.removeAt(rowIndex);
    _employeeDataSource?.updateDataGridSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('DataGrid CRUD Testing'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  child: const Text('Add row'),
                  onPressed: () {
                    addNewEmployee();
                  }),
              TextButton(
                  child: Text('Add Filter'),
                  onPressed: () {
                    _employeeDataSource?.addFilter('name',
                        const FilterCondition(type: FilterType.equals, value: 'Balnc'));
                  }),
              TextButton(
                  onPressed: () {
                    _employeeDataSource?.sortedColumns.add(const SortColumnDetails(
                        name: 'name', sortDirection: DataGridSortDirection.ascending));
                    _employeeDataSource?.sort();
                  },
                  child: Text('Apply sort')),
            ],
          ),
          _employeeDataSource != null
              ? SfDataGrid(
            //allowSorting: true,
                  //allowMultiColumnSorting: false,
                  allowSwiping: true,
                  swipeMaxOffset: 100.0,
                  source: _employeeDataSource as EmployeeDataSource,
                  endSwipeActionsBuilder:
                      (BuildContext context, DataGridRow row, int rowIndex) {
                    return GestureDetector(
                        onTap: () {
                          deleteEmployee(rowIndex);
                        },
                        child: Container(
                            color: Colors.redAccent,
                            child: const Center(
                              child: Icon(Icons.delete),
                            )));
                  },
                  columns: [
                    GridColumn(
                        columnName: 'id',
                        label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'ID',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'name',
                        label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Name',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'designation',
                        label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Designation',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'salary',
                        label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'Salary',
                              overflow: TextOverflow.ellipsis,
                            ))),
                  ],
                  selectionMode: SelectionMode.single,
                  onCellTap: (DataGridCellTapDetails details) {
                    final rowIndex = (details.rowColumnIndex.rowIndex);

                    //MY WORLD OF HURT

                     // if (_employeeDataSource != null && rowIndex >= 0 && rowIndex < _employeeDataSource!.dataGridRows.length) {
                     //   final dataGridRow = _employeeDataSource!
                     //       .dataGridRows[rowIndex - 1];
                     //   final id = dataGridRow
                     //       .getCells()
                     //       .firstWhere((cell) => cell.columnName == 'id')
                     //       .value;
                     //   final name = dataGridRow
                     //       .getCells()
                     //       .firstWhere((cell) => cell.columnName == 'name')
                     //       .value;
                     //   //   final designation = dataGridRow.getCells().firstWhere((cell) => cell.columnName == 'designation').value;
                     //   //   final salary = dataGridRow.getCells().firstWhere((cell) => cell.columnName == 'salary').value;
                     //   //
                     //   print('ID: $id');
                     //   print('Name: $name');
                     //   //   print('Designation: $designation');
                     //   //   print('Salary: $salary');
                     //   print(_employeeDataSource!.dataGridRows.length);
                     //}




                    if (rowIndex > 0) {
                      final theEmployee = _employees[rowIndex - 1];
                      //final theEmployee = _employeeDataSource!.dataGridRows[rowIndex -1];


                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(theEmployee: theEmployee)));
                    }
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<EmployeeCompanion> employees}) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id.value),
              DataGridCell<String>(
                  columnName: 'name', value: dataGridRow.name.value),
              DataGridCell<String>(
                  columnName: 'designation',
                  value: dataGridRow.designation.value),
              DataGridCell<int>(
                  columnName: 'salary', value: dataGridRow.salary.value),
            ]))
        .toList();
  }

  void buildDataGridRows(List<EmployeeCompanion> employees) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id.value),
              DataGridCell<String>(
                  columnName: 'name', value: dataGridRow.name.value),
              DataGridCell<String>(
                  columnName: 'designation',
                  value: dataGridRow.designation.value),
              DataGridCell<int>(
                  columnName: 'salary', value: dataGridRow.salary.value),
            ]))
        .toList();
    print(dataGridRows.length);
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'salary')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
