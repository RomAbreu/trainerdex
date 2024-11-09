import 'package:flutter/material.dart';
import 'package:trainerdex/constants/app_theme.dart';
import 'package:trainerdex/models/pokemon_move.dart';
import 'package:trainerdex/utils.dart';

class PokemonMovesContainer extends StatefulWidget {
  final Color pokemonColor;
  final List<PokemonMove> moves;

  const PokemonMovesContainer(
      {super.key, required this.pokemonColor, required this.moves});

  @override
  State<PokemonMovesContainer> createState() => _PokemonMovesContainerState();
}

class _PokemonMovesContainerState extends State<PokemonMovesContainer> {
  String _selectedMethod = 'Level Up';
  late Map<String, List<PokemonMove>> _movesMap;

  @override
  void initState() {
    super.initState();
    _movesMap = {
      'Level Up':
          widget.moves.where((move) => move.method == 'level-up').toList(),
      'Machine': widget.moves.where((move) => move.method == 'machine').toList()
        ..sort((a, b) => a.machineNumber!.compareTo(b.machineNumber!)),
      'Egg': widget.moves.where((move) => move.method == 'egg').toList(),
      'Tutor': widget.moves.where((move) => move.method == 'tutor').toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: _button('Level Up')),
          const SizedBox(width: 8),
          Expanded(child: _button('Machine')),
          const SizedBox(width: 8),
          Expanded(child: _button('Egg')),
          const SizedBox(width: 8),
          Expanded(child: _button('Tutor')),
        ]),
        const SizedBox(height: 16),
        if (_movesMap[_selectedMethod]!.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No moves found for this method',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        for (final move in _movesMap[_selectedMethod]!)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: movesContainer(move),
          ),
      ],
    );
  }

  Widget movesContainer(PokemonMove move) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: AppTheme.typeColors[move.type]!.withOpacity(1), width: 3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                height: 54,
                color: AppTheme.typeColors[move.type]!.withOpacity(1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(move.type.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(move.name,
                            style: TextStyle(
                                color: AppTheme.typeColors[move.type]!
                                    .withOpacity(1),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        Text(' ${Utils.capitalize(move.damageClass)}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                                fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      if (move.method == 'level-up') ...[
                        _richText('Lv', move.level.toString()),
                        const SizedBox(width: 8),
                      ],
                      if (move.method == 'machine' &&
                          move.machineNumber! > 100) ...[
                        _richText(
                            'HM', move.machineNumber.toString().substring(1)),
                        const SizedBox(width: 8),
                      ],
                      if (move.method == 'machine' &&
                          move.machineNumber! <= 100) ...[
                        _richText('TM', move.machineNumber.toString()),
                        const SizedBox(width: 8),
                      ],
                      _richText('PP', move.pp.toString()),
                      const SizedBox(width: 8),
                      _richText('Power',
                          move.power == null ? '-' : move.power.toString()),
                      const SizedBox(width: 8),
                      _richText(
                          'Acc',
                          move.accuracy == null
                              ? '-'
                              : move.accuracy.toString()),
                      const SizedBox(width: 8),
                    ])
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.info_outline,
                color: Colors.grey,
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _richText(String text, String subtext) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
        children: [
          TextSpan(
            text: ' $subtext',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = text;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Utils.lightenColor(
              widget.pokemonColor, _selectedMethod == text ? 0.6 : 0.85),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: widget.pokemonColor),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: widget.pokemonColor,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
      ),
    );
  }
}
