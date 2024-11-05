import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:trainerdex/utils.dart';

class PokemonBaseStats extends StatefulWidget {
  final Color pokemonColor;
  final List<int> stats;
  const PokemonBaseStats(
      {super.key, required this.pokemonColor, required this.stats});

  @override
  State<PokemonBaseStats> createState() => _PokemonBaseStatsState();
}

class _PokemonBaseStatsState extends State<PokemonBaseStats> {
  String _selectedStat = 'Base';
  List<int> _minStats = [];
  List<int> _maxStats = [];
  late Map<String, List<int>> _stats;
  final List<String> _bottomText = [
    'Base stats range from 0 to 255. They are the prime representation of the potential a Pokemon species has in battle.',
    'Min stats are the lowest possible stats a Pokemon can have at level 100 with 0 IVs, 0 EVs and a negative nature.',
    'Max stats are the highest possible stats a Pokemon can have at level 100 with 31 IVs, 252 EVs and a positive nature.'
  ];

  @override
  void initState() {
    super.initState();
    _minStats = _calculateStats('Min');
    _maxStats = _calculateStats('Max');
    _stats = {
      'Base': widget.stats,
      'Min': _minStats,
      'Max': _maxStats,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: _button('Base')),
          const SizedBox(width: 8),
          Expanded(child: _button('Min')),
          const SizedBox(width: 8),
          Expanded(child: _button('Max')),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: SizedBox(
            height: 240,
            child:
                RotatedBox(quarterTurns: 1, child: BarChart(_barChartData())),
          ),
        ),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: 'TOTAL',
              style: TextStyle(
                color: Utils.lightenColor(widget.pokemonColor, 0.5),
                fontSize: 20,
              )),
          TextSpan(
              text: ' ${_stats[_selectedStat]!.reduce((a, b) => a + b)}',
              style: TextStyle(
                  color: widget.pokemonColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ])),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            _bottomText[_stats.keys.toList().indexOf(_selectedStat)],
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  BarChartData _barChartData() {
    BarData barData = BarData(
      hp: _stats[_selectedStat]![0],
      attack: _stats[_selectedStat]![1],
      defense: _stats[_selectedStat]![2],
      specialAttack: _stats[_selectedStat]![3],
      specialDefense: _stats[_selectedStat]![4],
      speed: _stats[_selectedStat]![5],
    );

    barData.generateBarData();

    return BarChartData(
      barTouchData: barTouchData,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      minY: 0,
      maxY: _stats[_selectedStat]!.reduce(max).toDouble(),
      titlesData: flTitlesData,
      barGroups: barData.barData
          .map((bar) => BarChartGroupData(
              showingTooltipIndicators: [0],
              x: bar.x,
              barRods: [
                BarChartRodData(
                    backDrawRodData: BackgroundBarChartRodData(
                        color: Utils.lightenColor(widget.pokemonColor),
                        show: true,
                        toY: _stats[_selectedStat]!.reduce(max).toDouble()),
                    borderRadius: BorderRadius.circular(6.0),
                    toY: bar.y.toDouble(),
                    width: 32,
                    color: widget.pokemonColor)
              ]))
          .toList(),
    );
  }

  FlTitlesData get flTitlesData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _getBottomTitle,
              reservedSize: 80)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)));

  BarTouchData get barTouchData => BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
          rotateAngle: 270,
          tooltipHorizontalOffset: 8,
          direction: TooltipDirection.bottom,
          getTooltipColor: (_) => Colors.transparent,
          fitInsideVertically: true,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                  color: Utils.lightenColor(widget.pokemonColor),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            );
          }));

  Widget _getBottomTitle(double value, TitleMeta meta) {
    final style = TextStyle(
        color: widget.pokemonColor, fontSize: 16, fontWeight: FontWeight.bold);
    Widget text;

    switch (value.toInt()) {
      case 0:
        text = Text('HP', style: style);
        break;
      case 1:
        text = Text('Att', style: style);
        break;
      case 2:
        text = Text('Def', style: style);
        break;
      case 3:
        text = Text('Sp. Att', style: style);
        break;
      case 4:
        text = Text('Sp. Def', style: style);
        break;
      case 5:
        text = Text('Speed', style: style);
        break;
      default:
        text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: Utils.deg2rad(270),
      space: 28,
      child: text,
    );
  }

  Widget _button(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStat = text;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Utils.lightenColor(
              widget.pokemonColor, _selectedStat == text ? 0.6 : 0.85),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: widget.pokemonColor),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: widget.pokemonColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }

  List<int> _calculateStats(String minOrMax) {
    List<int> stats = [];
    int ivs = minOrMax == 'Min' ? 0 : 31;
    int evs = minOrMax == 'Min' ? 0 : 252 ~/ 4;

    // HP min stat formula
    stats.add(2 * widget.stats[0] + 110 + ivs + evs);

    // Rest of the stats min stat formula
    for (int i = 1; i < widget.stats.length; i++) {
      stats.add(((2 * widget.stats[i] + ivs + evs + 5) *
              (minOrMax == 'Min' ? 0.9 : 1.1))
          .toInt());
    }

    return stats;
  }
}

class IndividualBar {
  final int x;
  final int y;

  IndividualBar({required this.x, required this.y});
}

class BarData {
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;

  BarData(
      {required this.hp,
      required this.attack,
      required this.defense,
      required this.specialAttack,
      required this.specialDefense,
      required this.speed});

  List<IndividualBar> barData = [];

  void generateBarData() {
    barData = [
      IndividualBar(x: 0, y: hp),
      IndividualBar(x: 1, y: attack),
      IndividualBar(x: 2, y: defense),
      IndividualBar(x: 3, y: specialAttack),
      IndividualBar(x: 4, y: specialDefense),
      IndividualBar(x: 5, y: speed),
    ];
  }
}
