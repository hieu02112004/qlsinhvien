import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông Tin Nhóm')),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bài Tập Nhóm: Quản Lý Điểm Học Phần',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Lớp: IT', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Thành viên nhóm:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('- Nguyễn Mạnh Hùng', style: TextStyle(fontSize: 16)),
            Text('- Bùi Minh Hiếu', style: TextStyle(fontSize: 16)),
            Text('- Lưu Quang hưng', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
              'Ứng dụng được phát triển bằng Flutter và SQLite.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
