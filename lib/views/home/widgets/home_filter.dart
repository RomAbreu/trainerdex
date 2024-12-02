import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/constants/pokemon_types_util.dart';
import 'package:trainerdex/models/generation_info.dart';
import 'package:trainerdex/models/pokemon_ability.dart';
import 'package:trainerdex/repositories/pokemon_general_repository.dart';
import 'package:trainerdex/widgets/commons.dart';

class FilterBottomSheetContent extends StatefulWidget {
  final List<Tab> tabs = const [
    Tab(child: FittedBox(child: Text('Type'))),
    Tab(child: FittedBox(child: Text('Generation'))),
    Tab(child: FittedBox(child: Text('Ability'))),
  ];

  final VoidCallback refreshList;
  final VoidCallback updateOffset;
  final Future<void> Function() fetchPokemons;
  final List<String> typeFilterArgs;
  final int Function() selectedGeneration;
  final void Function(int) onChangedGeneration;
  final int pokemonsCounter;
  final Future<void> Function() refreshCounter;
  final List<int> abilitiesFilterArgs;

  const FilterBottomSheetContent({
    super.key,
    required this.fetchPokemons,
    required this.refreshList,
    required this.updateOffset,
    required this.typeFilterArgs,
    required this.selectedGeneration,
    required this.onChangedGeneration,
    required this.pokemonsCounter,
    required this.refreshCounter,
    required this.abilitiesFilterArgs,
  });

  @override
  State<FilterBottomSheetContent> createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<FilterBottomSheetContent>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        const BottomSheetHeader(title: 'Filter'),

        // Important filter content
        DefaultTabController(
          length: widget.tabs.length,
          child: TabBar(
            controller: _controller,
            unselectedLabelColor: Colors.black45,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: widget.tabs,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              TypeGridView(
                refreshList: widget.refreshList,
                fetchPokemons: widget.fetchPokemons,
                typeFilterArgs: widget.typeFilterArgs,
                pokemonsCounter: widget.pokemonsCounter,
                refreshCounter: widget.refreshCounter,
              ),
              GenerationView(
                selectedGeneration: widget.selectedGeneration,
                onChangedGeneration: widget.onChangedGeneration,
                refreshList: widget.refreshList,
                fetchPokemons: widget.fetchPokemons,
                pokemonsCounter: widget.pokemonsCounter,
                refreshCounter: widget.refreshCounter,
              ),
              AbilitiesView(
                abilitiesFilterArgs: widget.abilitiesFilterArgs,
                fetchPokemons: widget.fetchPokemons,
                refreshCounter: widget.refreshCounter,
                refreshList: widget.refreshList,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class TypeGridView extends StatefulWidget {
  final double chipFontSize = 15;
  final VoidCallback refreshList;
  final Future<void> Function() fetchPokemons;
  final List<String> typeFilterArgs;
  final int pokemonsCounter;
  final Future<void> Function() refreshCounter;

  const TypeGridView({
    super.key,
    required this.refreshList,
    required this.fetchPokemons,
    required this.typeFilterArgs,
    required this.pokemonsCounter,
    required this.refreshCounter,
  });

  @override
  State<TypeGridView> createState() => _TypeGridViewState();
}

class _TypeGridViewState extends State<TypeGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 4 / 3,
      children: [
        for (final type in PokemonType.values)
          TypeChip(
            type: type.name,
            fontSize: widget.chipFontSize,
            isClickable: true,
            currentFilters: widget.typeFilterArgs,
            afterAction: () {
              setState(() {
                if (widget.typeFilterArgs.contains(type.name)) {
                  widget.typeFilterArgs.remove(type.name);
                } else {
                  widget.typeFilterArgs.add(type.name);
                }
              });
              widget.refreshList();
              widget.fetchPokemons();
              widget.refreshCounter();
            },
          ),
      ],
    );
  }
}

class GenerationView extends StatefulWidget {
  final int Function() selectedGeneration;
  final void Function(int) onChangedGeneration;
  final VoidCallback refreshList;
  final Future<void> Function() fetchPokemons;
  final int pokemonsCounter;
  final Future<void> Function() refreshCounter;

  const GenerationView({
    super.key,
    required this.selectedGeneration,
    required this.onChangedGeneration,
    required this.refreshList,
    required this.fetchPokemons,
    required this.pokemonsCounter,
    required this.refreshCounter,
  });

  @override
  State<GenerationView> createState() => _GenerationViewState();
}

class _GenerationViewState extends State<GenerationView> {
  late final List<GenerationInfo> _generations = [];
  late int _currentSelection;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedGeneration();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchGenerations(context);
  }

  Future<void> _fetchGenerations(BuildContext context) async {
    final List<GenerationInfo> generations =
        await PokemonRepository.getGenerations(
            GraphQLProvider.of(context).value);
    setState(() {
      _generations.addAll(generations);
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        (_isFetching)
            ? const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  for (final generation in _generations)
                    Card.outlined(
                      color: _currentSelection == generation.id
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                      margin: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      child: InkWell(
                        splashColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          _changeGeneration(generation.id);
                          widget.refreshCounter();
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: generation.id,
                              groupValue: _currentSelection,
                              onChanged: (_) {
                                _changeGeneration(generation.id);
                                widget.refreshCounter();
                              },
                              toggleable: true,
                            ),
                            const Spacer(),
                            Text(generation.name,
                                style: const TextStyle(fontSize: 17)),
                            const SizedBox(width: 30)
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ],
    );
  }

  void _changeGeneration(int value) {
    setState(() {
      (_currentSelection == value)
          ? _currentSelection = 0
          : _currentSelection = value;
    });
    widget.onChangedGeneration(_currentSelection);
    widget.refreshList();
    widget.fetchPokemons();
  }
}

class AbilitiesView extends StatefulWidget {
  final List<int> abilitiesFilterArgs;
  final VoidCallback refreshList;
  final Future<void> Function() fetchPokemons;
  final Future<void> Function() refreshCounter;

  const AbilitiesView({
    super.key,
    required this.abilitiesFilterArgs,
    required this.fetchPokemons,
    required this.refreshCounter,
    required this.refreshList,
  });

  @override
  State<AbilitiesView> createState() => _AbilitiesViewState();
}

class _AbilitiesViewState extends State<AbilitiesView> {
  late ScrollController controller;
  final List<PokemonAbility> _abilities = [];
  int _totalAbilitiesCounter = 0;
  int _currentOffset = 0;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAbilities();
    refreshCounter();
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      updateOffset();
      fetchAbilities();
    }
  }

  Future<void> fetchAbilities() async {
    final List<PokemonAbility> abilities =
        await PokemonRepository.getAllAbilitiesWithOffset(
      GraphQLProvider.of(context).value,
      _currentOffset,
    );

    setState(() {
      _abilities.addAll(abilities);
    });
  }

  Future<void> refreshCounter() async {
    final int count = await PokemonRepository.countAbilities(
      GraphQLProvider.of(context).value,
    );
    setState(() {
      _totalAbilitiesCounter = count;
    });
  }

  updateOffset() {
    setState(() {
      _currentOffset += 60;
    });
  }

  abilityIsSelected(int id) {
    return widget.abilitiesFilterArgs.contains(id);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 1,
          ),
          itemCount: _abilities.length + 1,
          itemBuilder: (context, index) {
            if (index < _abilities.length) {
              return AbilityItem(
                ability: _abilities[index],
                isSelected: () =>
                    widget.abilitiesFilterArgs.contains(_abilities[index].id),
                onTap: () {
                  setState(
                    () {
                      (widget.abilitiesFilterArgs
                              .contains(_abilities[index].id))
                          ? widget.abilitiesFilterArgs
                              .remove(_abilities[index].id)
                          : widget.abilitiesFilterArgs
                              .add(_abilities[index].id!);
                    },
                  );
                  widget.refreshList();
                  widget.fetchPokemons();
                  widget.refreshCounter();
                },
              );
            }
            return null;
          },
        ),
        SliverToBoxAdapter(
          child: (_totalAbilitiesCounter > _abilities.length)
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox(height: 10),
        ),
      ],
    );
  }
}

class AbilityItem extends StatefulWidget {
  final PokemonAbility ability;
  final void Function() onTap;
  final bool Function() isSelected;

  const AbilityItem({
    super.key,
    required this.ability,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<AbilityItem> createState() => _AbilityItemState();
}

class _AbilityItemState extends State<AbilityItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: widget.isSelected()
            ? Theme.of(context).primaryColor.withOpacity(0.4)
            : Colors.transparent,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        onTap: widget.onTap,
        child: Center(
          child: Text(
            widget.ability.name,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}
