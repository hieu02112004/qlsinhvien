import 'package:flutter/material.dart';
import '../database_helper.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    final stats = await _dbHelper.getStatistics();
    setState(() {
      _stats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_stats == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final Student? maxSv = _stats!['max'];
    final Student? minSv = _stats!['min'];

    return Scaffold(
      appBar: AppBar(title: const Text('Thống Kê Báo Cáo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatCard('Tổng số sinh viên', _stats!['total'].toString(), Icons.people, Colors.blue),
            _buildStatCard('Số SV qua môn', _stats!['passed'].toString(), Icons.check_circle, Colors.green),
            if (maxSv != null)
              _buildStatCard('Điểm cao nhất', '${maxSv.hoTen} (${maxSv.diemThanhPhan})', Icons.trending_up, Colors.orange),
            if (minSv != null)
              _buildStatCard('Điểm thấp nhất', '${minSv.hoTen} (${minSv.diemThanhPhan})', Icons.trending_down, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
