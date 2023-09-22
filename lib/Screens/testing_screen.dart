import 'package:dgtesting/Screens/datagrid_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dgtesting/Database/myDB.dart' as db;
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;


class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});
  static String id = 'testing_screen';

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  late db.EmployeeDB _employeeDB;
  int records = 0;

  final employeesToInsert = [
    const db.EmployeeCompanion(
      name: drift.Value('James'),
      designation: drift.Value('Project Lead'),
      salary: drift.Value(20000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Kathryn'),
      designation: drift.Value('Manager'),
      salary: drift.Value(30000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Lara'),
      designation: drift.Value('Developer'),
      salary: drift.Value(15000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Michael'),
      designation: drift.Value('Designer'),
      salary: drift.Value(15000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Martin'),
      designation: drift.Value('Developer'),
      salary: drift.Value(15000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Newberry'),
      designation: drift.Value('Developer'),
      salary: drift.Value(15000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Balnc'),
      designation: drift.Value('Developer'),
      salary: drift.Value(15000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Perry'),
      designation: drift.Value('Developer'),
      salary: drift.Value(15000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Gable'),
      designation: drift.Value('Developer'),
      salary: drift.Value(15000),
    ),
    const db.EmployeeCompanion(
      name: drift.Value('Grimes'),
      designation: drift.Value('Developer'),
      salary: drift.Value(15000),
    ),
  ];

  @override
  void initState() {
    super.initState();
    initDB();
    updateCounter();
  }

  void initDB() async {
    try {
      _employeeDB = Provider.of<db.EmployeeDB>(context, listen: false);
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting results: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('DataGrid CRUD Testing'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Using this app to test the CRUD functions\nof using DataGrid with Drift\nand Provider',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            const Text('Current records in database:'),
            const Text('_________________'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$records', style: const TextStyle(color: Colors.orange, fontSize: 30),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: updateCounter, child: const Text('Refresh')),
                )
              ],
            ),
            const Text('_________________'),
            const SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () {

                insertAllEmployees(employeesToInsert);
              },
              child: const Text('Populate the Database'),
            ),
            const Text(
              'Fills the table with records\n keep pressing to put more in.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DataGridScreen()));
                },
                child: const Text('Load the DataGrid')),
            const SizedBox(
              height: 40,
              ),
            ElevatedButton(
                onPressed: () {
                  deleteAllData();
                },
                child: const Text('Delete All Data in Table'))
          ],
        ),
      ),
    );
  }

  Future<void> deleteAllData() async {
    await _employeeDB.delete(_employeeDB.employee).go();
    setState(() {
      updateCounter();
    });
  }

  Future<void> insertAllEmployees(List<db.EmployeeCompanion> employeesToInsert) async {
    for (var employee in employeesToInsert) {
      await _employeeDB.into(_employeeDB.employee).insert(employee);
      updateCounter();
    }
  }

  Future<void> updateCounter() async {
    final recordsCount = await _employeeDB.select(_employeeDB.employee).get();
    setState(() {
      records = recordsCount.length;
    });
  }

}
