import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/cloth.dart';
import 'screens/home_screen.dart';
import 'screens/wardrobe_screen.dart';
import 'screens/laundry_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ClothStateAdapter());
  Hive.registerAdapter(ClothAdapter());

  await Hive.openBox<Cloth>('clothesBox');

  runApp(const MyWardrobeApp());
}

class MyWardrobeApp extends StatelessWidget {
  const MyWardrobeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wardrobe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final Box<Cloth> clothesBox;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    clothesBox = Hive.box<Cloth>('clothesBox');

    _screens = [
      // 👇 ONLY Home has Drawer
      HomeScreen(clothesBox: clothesBox),

      // 👇 No drawer here
      WardrobeScreen(clothesBox: clothesBox),
      LaundryScreen(clothesBox: clothesBox),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: 'Wardrobe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_laundry_service),
            label: 'Laundry',
          ),
        ],
      ),
    );
  }
}
