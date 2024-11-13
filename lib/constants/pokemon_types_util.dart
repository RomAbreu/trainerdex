import 'package:flutter/material.dart';

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

const Map<String, Color> typeColors = {
  'normal': Color(0xFF929da3),
  'fighting': Color(0xFFce416b),
  'flying': Color(0xFF8fa9de),
  'rock': Color(0xFFc5b78c),
  'ground': Color(0xFFd97845),
  'poison': Color(0xFFaa6bc8),
  'bug': Color(0xFF91c12f),
  'ghost': Color(0xFF5269ad),
  'steel': Color(0xFF5a8ea2),
  'fire': Color(0xFFff9d55),
  'water': Color(0xFF5090d6),
  'grass': Color(0xFF63bc5a),
  'ice': Color(0xFF73cec0),
  'psychic': Color(0xFFfa7179),
  'electric': Color(0xFFf4d23c),
  'dragon': Color(0xFF0b6dc3),
  'dark': Color(0xFF5a5465),
  'fairy': Color(0xFFec8fe6),
  '???': Color(0xFF68a090),
};

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

    color = typeColors[widget.type] ?? typeColors['???']!;

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
            : typeColors[widget.type] ?? typeColors['???']!,
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
            color =
                (color == Colors.grey) ? typeColors[widget.type]! : Colors.grey;
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
