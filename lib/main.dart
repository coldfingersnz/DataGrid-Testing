import 'package:dgtesting/Database/myDB.dart';
import 'package:dgtesting/Screens/testing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    Provider<EmployeeDB>(
      create: (context) => EmployeeDB(),
      child: const DGTesting(),
      dispose: (context, db) => db.close(),
    ),
  );
}

class DGTesting extends StatelessWidget {
  const DGTesting({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: TestingScreen.id,
      routes: {
        TestingScreen.id: (context) => const TestingScreen(),
      },
    );
  }
}
