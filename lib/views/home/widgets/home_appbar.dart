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
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('TrainerDex'),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Image.asset('assets/icon-pokeball-closed.png'),
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
                    ));
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
