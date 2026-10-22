import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Данные аккаунта'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 24),
            const _ProfileHeader(),
            const SizedBox(height: 24),
            CupertinoListSection.insetGrouped(
              header: const Text('Личные данные'),
              backgroundColor: AppColors.accentCard.resolveFrom(context),
              children: const [
                CupertinoListTile(
                  leading: Icon(CupertinoIcons.person),
                  title: Text('ФИО'),
                  additionalInfo: Text('Не указано'),
                ),
                CupertinoListTile(
                  leading: Icon(CupertinoIcons.mail),
                  title: Text('Почта'),
                  additionalInfo: Text('Не указано'),
                ),
                CupertinoListTile(
                  leading: Icon(CupertinoIcons.phone),
                  title: Text('Телефон'),
                  additionalInfo: Text('Не указано'),
                ),
                CupertinoListTile(
                  leading: Icon(CupertinoIcons.calendar),
                  title: Text('ФИО'),
                  additionalInfo: Text('Не указано'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: CupertinoColors.systemGrey5,
          ),
          child: const Icon(
            CupertinoIcons.person_fill,
            size: 44,
            color: CupertinoColors.systemGrey,
          ),
        ),

        const SizedBox(height: 12),
        const Text(
          'Имя не указано',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
        
      ],
    );
  }
}
