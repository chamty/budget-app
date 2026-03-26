import 'package:flutter/material.dart';
import 'gacha_button.dart';

class GachaButtonGrid extends StatelessWidget {
  final List<int> amountList;
  final ValueChanged<int> onPressed;

  static const int _maxDisplayCount = 12;
  static const double _spacing = 15.0;
  static const int _columnCount = 3;

  const GachaButtonGrid({
    super.key,
    required this.amountList,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = amountList.take(_maxDisplayCount).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = 
              (constraints.maxWidth - (_spacing * (_columnCount - 1))) / _columnCount;

          return Wrap(
            alignment: WrapAlignment.center,
            spacing: _spacing,
            runSpacing: _spacing,
            children: displayItems.map((amount) {
              return SizedBox(
                width: buttonWidth,
                child: GachaButton(
                  label: '$amount円',
                  onPressed: () => onPressed(amount),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}