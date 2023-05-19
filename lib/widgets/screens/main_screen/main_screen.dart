import 'package:diplom/widgets/screens/main_screen/bottom_screens/home_screen.dart';
import 'package:diplom/widgets/screens/main_screen/bottom_screens/rate_screen.dart';
import 'package:diplom/widgets/screens/main_screen/bottom_screens/settings_screen.dart';
import 'package:flutter/material.dart';

class MainScren extends StatefulWidget {
  const MainScren({super.key});

  @override
  State<MainScren> createState() => _MainScrenState();
}

class _MainScrenState extends State<MainScren> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'Оценка'),
            BottomNavigationBarItem(
                icon: Icon(Icons.home_max), label: 'Главная'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: 'Настройки'),
          ]),
      body: Center(
        child:  [
          const RateScreen(),
          const HomeScreen(),
          const SettingsScreen()
        ][currentIndex],
      ),
    );
  }
}
