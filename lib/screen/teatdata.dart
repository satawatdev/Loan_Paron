// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;

//   static Database? _database;

//   DatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'your_database_name.db');

//     // เปิดหรือสร้างฐานข้อมูล
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   void _onCreate(Database db, int version) async {
//     // สร้างตารางและกำหนดรายละเอียดต่าง ๆ ของตาราง
//     await db.execute('''
//       CREATE TABLE your_table_name (
//         id INTEGER PRIMARY KEY,
//         column1 TEXT,
//         column2 INTEGER
//         -- เพิ่มคอลัมน์ตามต้องการ
//       )
//     ''');
//   }

//   // ฟังก์ชันเพิ่มข้อมูลลงในตาราง
//   Future<int> insertData(Map<String, dynamic> data) async {
//     final db = await database;
//     return await db.insert('your_table_name', data);
//   }

//   // ฟังก์ชันดึงข้อมูลทั้งหมดจากตาราง
//   Future<List<Map<String, dynamic>>> getAllData() async {
//     final db = await database;
//     return await db.query('your_table_name');
//   }

//   // เพิ่มฟังก์ชันอื่น ๆ ตามความต้องการ
// }
