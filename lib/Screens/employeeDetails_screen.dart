import 'package:dgtesting/Database/myDB.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({super.key, required this.theEmployee});

  late EmployeeCompanion theEmployee;


  @override
  State<DetailsScreen> createState() => _DetailsScreenState();

}

class _DetailsScreenState extends State<DetailsScreen> {

  String id = '';
  String name = '';
  String designation = '';
  String salary = '';

  TextStyle kText = const TextStyle(color: Colors.orange, fontSize: 30);

  @override
  void initState() {
    super.initState();
    EmployeeCompanion _employee = widget.theEmployee;
    setState(() {
      id = _employee.id.value.toString();
      name = _employee.name.value;
      designation = _employee.designation.value;
      salary = _employee.salary.value.toString();
    });
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
            Text('EMPLOYEE #$id SELECTED'),
            const Text('_________________'),
            const Text('Name:'),
            Text(name,style: kText),
            const SizedBox(height: 10,),
            const Text(
              'Designation:'),
            Text(designation,style: kText),
            const SizedBox(height: 10,),
            const Text(
                'Salary:'),
            Text(salary,style: kText),

          ],
        ),
      ),
    );
  }
}
