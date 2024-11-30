import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
      title: const TitleText(),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/icon-pokeball-closed.png',
            width: 30,
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
                    ));
          },
          icon: const Icon(Icons.filter_alt_outlined),
          iconSize: 30,
        ),
        const SizedBox(width: 5),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 10),
              const StyledSearchBar(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sort),
                iconSize: 30,
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class TitleText extends StatelessWidget {
  const TitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'Trainer',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const TextSpan(
          text: 'Dex',
          style: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ]),
    );
  }
}

class StyledSearchBar extends StatefulWidget {
  const StyledSearchBar({super.key});

  @override
  State<StyledSearchBar> createState() => _StyledSearchBarState();
}

class _StyledSearchBarState extends State<StyledSearchBar> {
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      contentPadding: const EdgeInsets.only(top: 5),
      hintText: 'Search for a Pokémon',
      prefixIcon: const Icon(Icons.search),
      filled: true,
      fillColor: Theme.of(context).primaryColor.withAlpha(50),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
        child: SizedBox(
          height: 40,
          child: TextField(
            style: const TextStyle(fontSize: 14),
            decoration: decoration,
          ),
        ),
      ),
    );
  }
}
