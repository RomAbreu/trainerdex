import 'package:flutter/material.dart';
import 'package:trainerdex/constants/app_theme.dart';

// CONSTANTS
enum PokemonType {
  normal,
  fighting,
  flying,
  rock,
  ground,
  poison,
  bug,
  ghost,
  steel,
  fire,
  water,
  grass,
  ice,
  psychic,
  electric,
  dragon,
  dark,
  fairy,
}

// WIDGETS
class TypeChip extends StatefulWidget {
  final String type;
  final double fontSize;
  final bool? isClickable;
  final List<String>? currentFilters;
  final void Function()? afterAction;

  const TypeChip({
    super.key,
    required this.type,
    required this.fontSize,
    this.isClickable,
    this.currentFilters,
    this.afterAction,
  });

  @override
  State<TypeChip> createState() => _TypeChipState();
}

class _TypeChipState extends State<TypeChip> {
  late Color color;
  bool colorChanged = false;
  bool get isSelected =>
      widget.currentFilters != null &&
      widget.currentFilters!.contains(widget.type);

  @override
  void initState() {
    super.initState();

    color = AppTheme.typeColors[widget.type] ?? AppTheme.typeColors['???']!;

    if (widget.isClickable == true && isSelected == false) {
      color = Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chip = Padding(
      padding: const EdgeInsets.only(right: 3.0),
      child: Chip(
        avatar: Image.asset('assets/${widget.type}.png'),
        label:
            Text('${widget.type[0].toUpperCase()}${widget.type.substring(1)}'),
        labelStyle: _typeStyle,
        backgroundColor: (widget.isClickable == true)
            ? color
            : AppTheme.typeColors[widget.type] ?? AppTheme.typeColors['???']!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.transparent),
        ),
        elevation: (isSelected) ? 8 : 0,
        shadowColor: color,
      ),
    );

    if (widget.isClickable != null && widget.isClickable!) {
      return GestureDetector(
        onTap: () {
          setState(() {
            color = (color == Colors.grey)
                ? AppTheme.typeColors[widget.type]!
                : Colors.grey;
            colorChanged = !colorChanged;
          });
          if (widget.afterAction != null) widget.afterAction!();
        },
        child: chip,
      );
    }

    return chip;
  }

  TextStyle get _typeStyle => TextStyle(
        fontSize: widget.fontSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );
}
