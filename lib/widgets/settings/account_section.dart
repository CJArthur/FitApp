import 'package:fitapp/l10n/app_localizations.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

// Пока нет авторизации, блок содержит только визуальные заглушки.
class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 28, 0, 12),
          child: Text(l10n.accountSection, style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey,
          )),
        ),
        // Нет onTap: эти строки пока не выполняют никаких действий.
        CupertinoListSection.insetGrouped(
          margin: EdgeInsets.zero,
          backgroundColor: CupertinoColors.transparent,
          decoration: BoxDecoration(
            color: AppColors.accentCard.resolveFrom(context),
            borderRadius: BorderRadius.circular(16),
          ),
          children: [
            CupertinoListTile(
              title: Text(l10n.changePassword, style: TextStyle(fontSize: 14)),
              trailing: Icon(CupertinoIcons.chevron_right, size: 14, color: CupertinoColors.systemGrey),
            ),
            CupertinoListTile(
              title: Text(l10n.linkSocial, style: TextStyle(fontSize: 14)),
              trailing: Icon(CupertinoIcons.chevron_right, size: 14, color: CupertinoColors.systemGrey),
            ),
            CupertinoListTile(
              title: Text(l10n.deleteAccount, style: TextStyle(fontSize: 14, color: CupertinoColors.systemRed)),
              trailing: Icon(CupertinoIcons.chevron_right, size: 14, color: CupertinoColors.systemGrey),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Semantics(
          button: true,
          enabled: false,
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemRed),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(l10n.signOut,
                style: TextStyle(color: CupertinoColors.systemRed, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.accountUnavailable,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
      ],
    );
  }
}
