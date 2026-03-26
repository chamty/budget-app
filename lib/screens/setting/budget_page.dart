import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../utils/snackbar.dart';

class BudgetSettingPage extends StatefulWidget {
  const BudgetSettingPage({super.key});

  @override
  State<BudgetSettingPage> createState() => _BudgetSettingPageState();
}

class _BudgetSettingPageState extends State<BudgetSettingPage> {
  final TextEditingController _budgetController = TextEditingController();
  int _currentBudget = 0;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentBudget = prefs.getInt('total_budget') ?? 0;
      _budgetController.text = _currentBudget.toString();
    });
  }

  Future<void> _saveBudget() async {
    final text = _budgetController.text;
    final val = int.tryParse(text);

    if (val == null || val < 0) {
      SnackbarUtils.show(context, '正しい金額を入力してください', isError: true);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_budget', val);

    setState(() {
      _currentBudget = val; 
    });

    if (mounted) {
      SnackbarUtils.show(context, '変更しました', isError: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(title: const Text('設定'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentBudget(formatter),
            const SizedBox(height: 32),
            _buildInputLabel(),
            const SizedBox(height: 12),
            _buildBudgetInput(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  /// 現在の予算表示
  Widget _buildCurrentBudget(NumberFormat formatter) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '今月の予算',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            Text(
              '${formatter.format(_currentBudget)}円',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.basicText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel() {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        '予算を変更',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.basicText,
        ),
      ),
    );
  }

  /// 入力欄
  Widget _buildBudgetInput() {
    return TextField(
      controller: _budgetController,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: '例: 1000',
        hintStyle: TextStyle(
          color: AppColors.basicText.withValues(alpha: 0.3),
          fontSize: 16,
        ),
        suffixText: '円',
        suffixStyle: TextStyle(
          color: AppColors.basicText,
          fontSize: 16,
        ),
      ),
    );
  }

  /// 保存ボタン
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveBudget,
        child: const Text(
          '保存',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}