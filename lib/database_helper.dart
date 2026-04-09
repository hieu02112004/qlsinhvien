import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';

class Student {
  int? id;
  String maSv;
  String hoTen;
  String ngaySinh;
  double diemThanhPhan;

  Student({
    this.id,
    required this.maSv,
    required this.hoTen,
    required this.ngaySinh,
    required this.diemThanhPhan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ma_sv': maSv,
      'ho_ten': hoTen,
      'ngay_sinh': ngaySinh,
      'diem_thanh_phan': diemThanhPhan,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      maSv: map['ma_sv'],
      hoTen: map['ho_ten'],
      ngaySinh: map['ngay_sinh'],
      diemThanhPhan: map['diem_thanh_phan'],
    );
  }

  double get diemTongKet => diemThanhPhan;

  String get diemChu {
    if (diemTongKet >= 8.5) return 'A';
    if (diemTongKet >= 7.0) return 'B';
    if (diemTongKet >= 5.5) return 'C';
    if (diemTongKet >= 4.0) return 'D';
    return 'F';
  }

  double get diemTichLuy {
    if (diemTongKet >= 8.5) return 4.0;
    if (diemTongKet >= 7.0) return 3.0;
    if (diemTongKet >= 5.5) return 2.0;
    if (diemTongKet >= 4.0) return 1.0;
    return 0.0;
  }

  bool get duTuCachThi => diemThanhPhan >= 4.0;
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'student_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, ma_sv TEXT, ho_ten TEXT, ngay_sinh TEXT, diem_thanh_phan REAL)',
        );
      },
    );
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }

  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final students = await getStudents();
    if (students.isEmpty) {
      return {'passed': 0, 'max': null, 'min': null, 'total': 0};
    }
    int passed = students.where((s) => s.diemTongKet >= 4.0).length;
    Student maxSv = students.reduce((curr, next) => curr.diemTongKet > next.diemTongKet ? curr : next);
    Student minSv = students.reduce((curr, next) => curr.diemTongKet < next.diemTongKet ? curr : next);
    return {
      'passed': passed,
      'max': maxSv,
      'min': minSv,
      'total': students.length,
    };
  }

  Future<void> seedData() async {
    final db = await database;
    // Dòng dưới đây sẽ xóa toàn bộ dữ liệu cũ để cập nhật định dạng mã SV mới
    await db.delete('students'); 
    
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM students'));
    if (count == 0) {
      final random = Random();
      for (int i = 1; i <= 70; i++) {
        String randomSuffix = random.nextInt(1000).toString().padLeft(3, '0');
        String studentId = '20220$randomSuffix';

        await insertStudent(Student(
          maSv: studentId,
          hoTen: 'Sinh viên $i',
          ngaySinh: '2004-01-01',
          diemThanhPhan: (i % 10).toDouble(),
        ));
      }
    }
  }
}
