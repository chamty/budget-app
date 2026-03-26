import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import 'budget_page.dart';
import 'price_button_page.dart';
import '../../utils/snackbar.dart';

class SettingItem {
  final IconData icon;
  final String title;
  final Widget? page;
  final bool isDestructive;
  final VoidCallback? onTap;

  const SettingItem({
    required this.icon,
    required this.title,
    this.page,
    this.isDestructive = false,
    this.onTap,
  });
}

class SettingPage extends StatefulWidget  {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

Future<void> _resetData() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('total_budget', 0);
  await prefs.setInt('used_amount', 0);
  await prefs.setStringList('amount_list', ['300', '400']);

  if (mounted) {
    SnackbarUtils.show(context, '初期化しました', isError: false);
  }
}

  /// 初期化の確認ダイアログ
  Future<void> _showResetConfirmation() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('データの初期化'),
          content: const Text('全データをリセットしますか？\nこの操作は取り消せません。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetData();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('実行'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<SettingItem> items = [
      const SettingItem(
        icon: Icons.attach_money,
        title: '金額ボタン設定',
        page: CustomAmountPage(),
      ),
      const SettingItem(
        icon: Icons.account_balance_wallet,
        title: '予算設定',
        page: BudgetSettingPage(),
      ),
      SettingItem(
        icon: Icons.delete_forever,
        title: 'アプリ初期化',
        isDestructive: true,
        onTap: () => _showResetConfirmation(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('設定'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildSettingCard(context, items[index]);
        },
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, SettingItem item) {
    final Color textColor = item.isDestructive ? Colors.red : AppColors.basicText;
    final Color iconColor = item.isDestructive ? Colors.red : AppColors.primary;

    return Card(
      child: ListTile(
        leading: Icon(item.icon, color: iconColor),
        title: Text(
          item.title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _handleTap(context, item),
      ),
    );
  }

  void _handleTap(BuildContext context, SettingItem item) {
    if (item.onTap != null) {
      item.onTap!();
      return;
    }

    if (item.page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => item.page!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.title} は準備中です')),
      );
    }
  }
}