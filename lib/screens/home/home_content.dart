import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/home/budget_pie_chart.dart';
import '../../widgets/home/gacha_button_grid.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  int _setBudget = 0;
  int _usedAmount = 0;
  List<int> _priceButtons = [300, 400];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }


  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final List<String>? storedList = prefs.getStringList('amount_list');

    setState(() {
      _setBudget = prefs.getInt('total_budget') ?? 0;
      _usedAmount = prefs.getInt('used_amount') ?? 0;

      if (storedList != null) {
        _priceButtons = storedList.map((e) => int.parse(e)).toList();
      } else {
        _priceButtons = [300, 400];
      }
    });
  }

  // 支出加算
  Future<void> _addExpense(int price) async {
    setState(() {
      _usedAmount += price;
    });
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('used_amount', _usedAmount);
  }

  Future<void> reload() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final remainingBudget = _setBudget - _usedAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yyyy年M月').format(DateTime.now())),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            BudgetPieChart(
              budget: remainingBudget, 
              totalBudget: _setBudget,
              usedAmount: _usedAmount,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _priceButtons.isEmpty
              ? Column(
                  children: [
                    const SizedBox(height: 12),
                    Icon(Icons.info_outline, color: Colors.grey.shade400, size: 40),
                    const SizedBox(height: 12),
                    const Text(
                      '金額ボタンがありません',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const Text(
                    '設定 > カスタム金額管理 から追加してください',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                )
              : GachaButtonGrid(
                  amountList: _priceButtons,
                  onPressed: _addExpense,
                ),
              ),
          ],
        ),
      ),
    );
  }
}