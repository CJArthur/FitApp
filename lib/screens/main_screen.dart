import 'package:fitapp/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const Center(child: Text('Тренировки')),
    const Center(child: Text('Настройки')),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: screens[currentIndex]),

            CupertinoTabBar(
              currentIndex: currentIndex,

              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Главная',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_list),
                  label: 'Тренировки',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: 'Аккаунт',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
