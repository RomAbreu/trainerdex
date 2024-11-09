import 'package:flutter/material.dart';
import 'package:trainerdex/utils.dart';

class PokemonInfoContainer extends StatefulWidget {
  final String title;
  final Color pokemonColor;
  final Widget child;
  const PokemonInfoContainer({
    super.key,
    required this.title,
    required this.pokemonColor,
    required this.child,
  });

  @override
  State<PokemonInfoContainer> createState() => _PokemonInfoContainerState();
}

class _PokemonInfoContainerState extends State<PokemonInfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
            color: Utils.darkenColor(widget.pokemonColor, 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                color: Utils.lightenColor(widget.pokemonColor),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color: Utils.darkenColor(widget.pokemonColor, 0.1),
                width: 1,
              ),
              left: BorderSide(
                color: Utils.darkenColor(widget.pokemonColor, 0.1),
                width: 1,
              ),
              right: BorderSide(
                color: Utils.darkenColor(widget.pokemonColor, 0.1),
                width: 1,
              ),
            ),
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
