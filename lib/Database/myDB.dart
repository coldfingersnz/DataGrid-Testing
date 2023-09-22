import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:flutter/foundation.dart';
part 'myDB.g.dart';


class Employee extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get designation => text()();
  IntColumn get salary => integer()();
}

@DriftDatabase(tables: [Employee])
class EmployeeDB extends _$EmployeeDB {
  EmployeeDB() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<EmployeeCompanion?> getSelectedEmployee(int forRecord) async {

    final query = select(employee)..where((tbl) => tbl.id.equals(forRecord));
    final theEmployee = await query.getSingle();

    if (theEmployee != null){
      return EmployeeCompanion(
        id: Value(theEmployee.id),
        name: Value(theEmployee.name),
        designation: Value(theEmployee.designation),
        salary: Value(theEmployee.salary),

      );
    }
    return null;
  }


}
QueryExecutor _openConnection() {
  return SqfliteQueryExecutor.inDatabaseFolder(path: 'myTestDB.sqlite');
}