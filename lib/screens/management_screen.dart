import 'package:flutter/material.dart';
import '../database_helper.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _refreshStudentList();
  }

  void _refreshStudentList() async {
    final data = await _dbHelper.getStudents();
    setState(() {
      _students = data;
    });
  }

  void _showForm(Student? student) async {
    final maSvController = TextEditingController(text: student?.maSv ?? '');
    final hoTenController = TextEditingController(text: student?.hoTen ?? '');
    final ngaySinhController = TextEditingController(text: student?.ngaySinh ?? '2005-01-01');
    final diemController = TextEditingController(text: student?.diemThanhPhan.toString() ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                student == null ? 'Thêm Sinh Viên Mới' : 'Chỉnh Sửa Thông Tin',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(controller: maSvController, decoration: const InputDecoration(labelText: 'Mã SV')),
              TextField(controller: hoTenController, decoration: const InputDecoration(labelText: 'Họ và Tên')),
              TextField(controller: ngaySinhController, decoration: const InputDecoration(labelText: 'Ngày Sinh (YYYY-MM-DD)')),
              TextField(
                controller: diemController,
                decoration: const InputDecoration(labelText: 'Điểm Thành Phần'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () async {
                  final double? inputDiem = double.tryParse(diemController.text);
                  
                  if (inputDiem == null || inputDiem < 0 || inputDiem > 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lỗi: Điểm phải nằm trong khoảng từ 0 đến 10!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final newStudent = Student(
                    id: student?.id,
                    maSv: maSvController.text,
                    hoTen: hoTenController.text,
                    ngaySinh: ngaySinhController.text,
                    diemThanhPhan: inputDiem,
                  );

                  if (student == null) {
                    await _dbHelper.insertStudent(newStudent);
                  } else {
                    await _dbHelper.updateStudent(newStudent);
                  }
                  _refreshStudentList();
                  Navigator.of(context).pop();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã lưu dữ liệu!'), backgroundColor: Colors.green),
                  );
                },
                child: Text(student == null ? 'Thêm Mới' : 'Cập Nhật'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Chúng ta giữ lại Scaffold nhưng KHÔNG CÓ AppBar để tránh bị chồng lấn với main.dart
    return Scaffold(
      body: _students.isEmpty
          ? const Center(child: Text('Danh sách trống'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              physics: const AlwaysScrollableScrollPhysics(), // Đảm bảo luôn cuộn được
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final s = _students[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: s.duTuCachThi ? Colors.blue.shade100 : Colors.red.shade100,
                      child: Text(s.diemChu, style: TextStyle(color: s.duTuCachThi ? Colors.blue : Colors.red, fontWeight: FontWeight.bold)),
                    ),
                    title: Text('${s.maSv} - ${s.hoTen}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ngày sinh: ${s.ngaySinh}'),
                        Text('Điểm: ${s.diemThanhPhan} | Kết quả: ${s.duTuCachThi ? "Đạt" : "Hỏng"}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(s)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(s),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(Student s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa sinh viên ${s.hoTen}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () async {
              await _dbHelper.deleteStudent(s.id!);
              _refreshStudentList();
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
