import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import '../../utils/snackbar.dart';

class CustomAmountPage extends StatefulWidget {
  const CustomAmountPage({super.key});

  @override
  State<CustomAmountPage> createState() => _CustomAmountPageState();
}

class _CustomAmountPageState extends State<CustomAmountPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  List<int> _amountList = [];
  List<int> _manualOrder = [];
  String _sortMode = 'custom';
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _editController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('amount_list');
    final manual = prefs.getStringList('manual_order');
    final sort = prefs.getString('sort_mode');

    setState(() {
      _amountList = list?.map(int.parse).toList() ?? [300, 400];
      _manualOrder = manual?.map(int.parse).toList() ?? List.from(_amountList);
      _sortMode = sort ?? 'custom';
      _applySort();
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('amount_list', _amountList.map((e) => e.toString()).toList());
    await prefs.setStringList('manual_order', _manualOrder.map((e) => e.toString()).toList());
    await prefs.setString('sort_mode', _sortMode);
  }

  void _applySort() {
    if (_sortMode == 'asc') {
      _amountList.sort((a, b) => a.compareTo(b));
    } else if (_sortMode == 'desc') {
      _amountList.sort((a, b) => b.compareTo(a));
    } else {
      _amountList = List.from(_manualOrder);
    }
  }

Future<void> _addOrUpdateAmount() async {
    final isEditing = _editingIndex != null;
    final text = isEditing ? _editController.text : _inputController.text;
    
    final value = int.tryParse(text);
    if (value == null || value <= 0) {
      SnackbarUtils.show(context, '正しい金額を入力してください', isError: true);
      return;
    }

    final isDuplicate = _amountList.asMap().entries.any((entry) => 
        entry.value == value && entry.key != _editingIndex);

    if (isDuplicate) {
      SnackbarUtils.show(context, '同じ金額は登録できません', isError: true);
      return;
    }

    setState(() {
      if (isEditing) {
        final oldAmount = _amountList[_editingIndex!];
        _amountList[_editingIndex!] = value;
        
        final i = _manualOrder.indexOf(oldAmount);
        if (i != -1) _manualOrder[i] = value;
        
        _editingIndex = null;
        _editController.clear();
      } else {
        _amountList.add(value);
        _manualOrder.add(value);
        _inputController.clear();
      }
      
      _applySort();
    });
    
    await _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('カスタム金額管理'), centerTitle: true),
      body:Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildSortSegmentedButton(),
            const SizedBox(height: 8),
            _buildHelpText(),
            Expanded(child: _buildAmountList()),
          ],
        ),
      ),
    );
  }

// 並び替えモード切替ボタン
  Widget _buildSortSegmentedButton() {
    return SegmentedButton<String>(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.2),
        selectedForegroundColor: AppColors.primary,
        side: BorderSide(color: Colors.grey.shade300),
      ),
      segments: const [
        ButtonSegment(value: 'custom', label: Text('手動'), icon: Icon(Icons.touch_app_outlined)),
        ButtonSegment(value: 'asc', label: Text('昇順'), icon: Icon(Icons.arrow_upward)),
        ButtonSegment(value: 'desc', label: Text('降順'), icon: Icon(Icons.arrow_downward)),
      ],
      selected: {_sortMode},
      onSelectionChanged: (value) {
        setState(() {
          _sortMode = value.first;
          _applySort();
        });
        _saveData();
      },
    );
  }

// 補助テキスト
  Widget _buildHelpText() {
    final message = _sortMode == 'custom' 
      ? '長押し＆上下にドラッグで並び替え、左スワイプで削除できます' 
      : '左スワイプで削除できます';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

// 金額一覧
Widget _buildAmountList() {
  return ReorderableListView.builder(
    buildDefaultDragHandles: false,
    itemCount: _amountList.length + 1,
    proxyDecorator: (Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Material(
            elevation: 8,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: child,
          );
        },
        child: child,
      );
    },
    onReorder: (oldIdx, newIdx) async {
      if (_sortMode != 'custom') return;
      if (oldIdx >= _amountList.length || newIdx > _amountList.length) return;

      setState(() {
        if (newIdx > oldIdx) newIdx--;
        final item = _amountList.removeAt(oldIdx);
        _amountList.insert(newIdx, item);
        _manualOrder = List.from(_amountList);
      });
      
      await _saveData();
    },
    itemBuilder: (context, index) {
      if (index == _amountList.length) return _buildInputRow();
      return _buildAmountTile(index);
    },
  );
}

Widget _buildAmountTile(int index) {
  final amount = _amountList[index];
  final isEditing = _editingIndex == index;

  return ReorderableDelayedDragStartListener(
    key: ValueKey('amount_$index'), 
    index: index,
    enabled: _sortMode == 'custom',
    child: Dismissible(
      key: ValueKey('dismiss_$amount'),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      onDismissed: (_) async {
        final targetValue = amount;
        setState(() {
          _amountList.remove(targetValue);
          _manualOrder.remove(amount);
        });
        await _saveData();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      _buildLeadingIcon(index),
                      const SizedBox(width: 16),
                      Expanded(
                        child: isEditing 
                            ? _buildEditTextField() 
                            : _buildAmountText(amount),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(Icons.edit_outlined, size: 18, color: Colors.grey.shade400),
                  onPressed: () {
                    setState(() {
                      _editingIndex = index;
                      _editController.text = amount.toString();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// 金額編集欄
  Widget _buildEditTextField() {
    return TextField(
      controller: _editController,
      autofocus: true,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(border: InputBorder.none, suffixText: '円'),
      onSubmitted: (_) => _addOrUpdateAmount(),
    );
  }

// 金額表示テキスト
  Widget _buildAmountText(int amount) {
    return Text('$amount円', style: TextStyle(color: AppColors.basicText, fontWeight: FontWeight.bold));
  }

// ドラッグ並び替えアイコン
  Widget _buildLeadingIcon(int index) {
    if (_sortMode == 'custom') {
      return ReorderableDragStartListener(
        index: index,
        child: Icon(Icons.drag_handle, color: AppColors.primary),
      );
    }
    return const Icon(Icons.lock_outline, size: 20, color: Colors.grey);
  }

  // スワイプ削除
  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

// 新規追加入力欄
  Widget _buildInputRow() {
    return Card(
      key: const ValueKey('input'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addOrUpdateAmount(),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '例：1000',
                  hintStyle: TextStyle(
                    color: Colors.grey, 
                    fontSize: 14,
                  ),
                  suffixText: '円',
                  suffixStyle: TextStyle(
                    color: AppColors.basicText,
                    fontWeight: FontWeight.normal,
                  ),
                  border: InputBorder.none
                ),
              ),
            ),
            TextButton(
              onPressed: _addOrUpdateAmount,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}