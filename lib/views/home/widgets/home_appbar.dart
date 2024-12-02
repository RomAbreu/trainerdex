import 'package:flutter/material.dart';
import 'package:trainerdex/views/home/widgets/home_filter.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback refreshList;
  final VoidCallback updateOffset;
  final Future<void> Function() fetchPokemons;
  final List<String> typeFilterArgs;
  final int Function() selectedGeneration;
  final void Function(int) onChangedGeneration;
  final int pokemonsCounter;
  final Future<void> Function() refreshCounter;
  final VoidCallback updateShowFavorites;
  final bool showFavorites;

  const HomeAppBar({
    super.key,
    required this.fetchPokemons,
    required this.refreshList,
    required this.updateOffset,
    required this.typeFilterArgs,
    required this.selectedGeneration,
    required this.onChangedGeneration,
    required this.pokemonsCounter,
    required this.refreshCounter,
    required this.updateShowFavorites,
    required this.showFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('TrainerDex'),
      actions: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            );
          },
          child: IconButton(
            key: ValueKey<bool>(showFavorites),
            onPressed: () {
              updateShowFavorites();
              refreshList();
              fetchPokemons();
              refreshCounter();
            },
            icon: showFavorites
                ? Image.asset('assets/pokeball_selected.png', width: 32)
                : Image.asset('assets/pokeball_unselected.png', width: 32),
          ),
        ),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => FilterBottomSheetContent(
                fetchPokemons: fetchPokemons,
                refreshList: refreshList,
                updateOffset: updateOffset,
                typeFilterArgs: typeFilterArgs,
                selectedGeneration: selectedGeneration,
                onChangedGeneration: onChangedGeneration,
                pokemonsCounter: pokemonsCounter,
                refreshCounter: refreshCounter,
              ),
            );
          },
          icon: const Icon(Icons.filter_alt_outlined),
          iconSize: 35,
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
