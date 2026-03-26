import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';

class BudgetPieChart extends StatelessWidget {
  final int budget;
  final int totalBudget;
  final int usedAmount;

  const BudgetPieChart({
    super.key,
    required this.budget,
    required this.totalBudget,
    required this.usedAmount,
  });

  String _format(int value) => NumberFormat('#,###').format(value);

  @override
  Widget build(BuildContext context) {
    final remainingDisplay = budget > 0 ? budget.toDouble() : 0.0;
    final isOverBudget = budget < 0;

    return SizedBox(
      height: 200,
      child: PieChart(
        dataMap: {
          "残り": remainingDisplay,
          "使用済": usedAmount.toDouble(),
        },
        chartType: ChartType.ring,
        chartRadius: MediaQuery.of(context).size.width / 2.2,
        ringStrokeWidth: 12,
        colorList: [
          AppColors.budgetRemaining,
          AppColors.budgetUsed,
        ],
        initialAngleInDegree: -90,
        chartValuesOptions: const ChartValuesOptions(showChartValues: false),
        // legendOptions: const LegendOptions(showLegends: false),
        centerWidget: _buildCenterContent(usedAmount, isOverBudget),
      ),
    );
  }

  Widget _buildCenterContent(int usedAmount, bool isOverBudget) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '残り予算',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),

          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _format(budget),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isOverBudget ? Colors.red : AppColors.basicText,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                '円',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 80,
            height: 1,
            color: AppColors.basicText.withValues(alpha: 0.2),
          ),

          Text(
            '${_format(usedAmount)}円 使用済',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}