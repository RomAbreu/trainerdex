import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:trainerdex/utils.dart';

class PokemonBasicInfo extends StatefulWidget {
  final int height;
  final int weight;
  final int baseExperience;
  final String cries;
  final Color pokemonColor;

  const PokemonBasicInfo(
      {super.key,
      required this.pokemonColor,
      required this.height,
      required this.weight,
      required this.baseExperience,
      required this.cries});

  @override
  PokemonBasicInfoState createState() => PokemonBasicInfoState();
}

class PokemonBasicInfoState extends State<PokemonBasicInfo>
    with TickerProviderStateMixin {
  late double heightInMeters;
  late double weightInKilograms;
  late AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    heightInMeters = Utils.convertDecimetersToMeters(widget.height);
    weightInKilograms = Utils.convertHectogramsToKilograms(widget.weight);
    _audioPlayer.onPlayerComplete.listen((event) {
      _controller.reverse();
    });
  }

  Future<void> _playCry() async {
    try {
      await _audioPlayer.play(UrlSource(widget.cries));
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(children: [
      Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('Height',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
                Text('$heightInMeters m',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(
            height: 35,
            child: VerticalDivider(
              thickness: 1,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('Weight',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
                Text('$weightInKilograms kg',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        height: 20,
        width: size.width * 0.75,
        child: const Divider(),
      ),
      Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('Base Experience',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
                Text('${widget.baseExperience}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(
            height: 35,
            child: VerticalDivider(
              thickness: 1,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('Cry',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
                GestureDetector(
                  onTap: () async {
                    await _playCry();
                    _controller.forward();
                  },
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _controller,
                    size: 35,
                    color: Utils.lightenColor(widget.pokemonColor, 0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
