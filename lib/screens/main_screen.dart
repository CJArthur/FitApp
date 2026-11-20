import 'package:fitapp/l10n/app_localizations.dart';
import 'package:fitapp/screens/home_screen.dart';
import 'package:fitapp/screens/settings_screen.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Подписи экранов читаем заново при изменении языка.
    final List<Widget> screens = [
      const HomeScreen(),
      Center(child: Text(l10n.workouts)),
      const SettingsScreen(),
    ];

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: screens[currentIndex]),

            CupertinoTabBar(
              currentIndex: currentIndex,

              // Граница таб панели
              border: Border(
                top: BorderSide(
                  color: AppColors.tabBarBorder.resolveFrom(context),
                  width: 1.0
                )
              ),

              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },

              items: [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_list),
                  label: l10n.workouts,
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: l10n.account,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
