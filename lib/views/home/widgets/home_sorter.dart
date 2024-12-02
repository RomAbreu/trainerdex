import 'package:flutter/material.dart';
import 'package:trainerdex/widgets/commons.dart';

class SorterBottomSheetContent extends StatefulWidget {
  final int selectedSortOption;
  final int selectedOrderOption;
  final void Function(int value) onChangedSortOption;
  final void Function(int value) onChangedOrderOption;

  const SorterBottomSheetContent({
    super.key,
    required this.selectedSortOption,
    required this.selectedOrderOption,
    required this.onChangedSortOption,
    required this.onChangedOrderOption,
  });

  @override
  State<SorterBottomSheetContent> createState() =>
      _SorterBottomSheetContentState();
}

class _SorterBottomSheetContentState extends State<SorterBottomSheetContent> {
  final List<String> _sortOrderOptions = [
    'Ascending',
    'Descending',
  ];
  final List<String> _sortByOptions = [
    'Number',
    'Name (A-Z)',
    'Type',
    'Ability',
  ];
  late int _orderSelected;
  late int _optionSelected;

  @override
  void initState() {
    super.initState();
    _orderSelected = widget.selectedOrderOption;
    _optionSelected = widget.selectedSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const BottomSheetHeader(title: 'Sort by'),
        for (final option in _sortByOptions)
          SortOptionCard(
            option: option,
            isSelected: _sortByOptions.indexOf(option) == _optionSelected,
            onTap: () {
              setState(() {
                _optionSelected = _sortByOptions.indexOf(option);
              });
              widget.onChangedSortOption(_optionSelected);
            },
            onChanged: (int? value) {
              setState(() {
                _optionSelected = value!;
              });
              widget.onChangedSortOption(_optionSelected);
            },
            value: _sortByOptions.indexOf(option),
            groupValue: _optionSelected,
          ),
        const SizedBox(height: 10),
        const Text('Order',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final option in _sortOrderOptions)
              SortOptionCard(
                option: option,
                isSelected: _sortOrderOptions.indexOf(option) == _orderSelected,
                onTap: () {
                  setState(() {
                    _orderSelected = _sortOrderOptions.indexOf(option);
                  });
                  widget.onChangedOrderOption(_orderSelected);
                },
                onChanged: (int? value) {
                  setState(() {
                    _orderSelected = value!;
                  });
                  widget.onChangedOrderOption(_orderSelected);
                },
                value: _sortOrderOptions.indexOf(option),
                groupValue: _orderSelected,
              ),
          ],
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class SortOptionCard extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<int?> onChanged;
  final int value;
  final int groupValue;

  const SortOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.onChanged,
    required this.value,
    required this.groupValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.1)
          : Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              toggleable: true,
            ),
            Text(option, style: const TextStyle(fontSize: 17)),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
