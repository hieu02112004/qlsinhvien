import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'screens/welcome_screen.dart';
import 'screens/management_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.seedData(); // Khởi tạo 70 sinh viên mẫu nếu database trống
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Điểm IT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const WelcomeScreen(),
    const ManagementScreen(),
    const StatisticsScreen(),
    const AboutScreen(),
  ];

  final List<String> _titles = [
    'Chào mừng',
    'Quản lý Sinh viên',
    'Thống kê báo cáo',
    'Thông tin nhóm',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Đóng drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 
          ? null // Không hiện AppBar ở màn hình chào mừng
          : AppBar(
              title: Text(_titles[_selectedIndex]),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Menu Quản Lý',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Trang chủ', 0),
            _buildDrawerItem(Icons.person, 'Quản lý SV', 1),
            _buildDrawerItem(Icons.bar_chart, 'Thống kê', 2),
            _buildDrawerItem(Icons.info, 'Giới thiệu', 3),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? Colors.blue : null),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.blue : null,
          fontWeight: _selectedIndex == index ? FontWeight.bold : null,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () => _onItemTapped(index),
    );
  }
}
