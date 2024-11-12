import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/constants/pokemon_types_util.dart';
import 'package:trainerdex/models/generation_info.dart';
import 'package:trainerdex/repositories/pokemon_general_repository.dart';

class FilterBottomSheetContent extends StatefulWidget {
  final List<Tab> tabs = const [
    Tab(child: FittedBox(child: Text('Type'))),
    Tab(child: FittedBox(child: Text('Generation'))),
    Tab(child: FittedBox(child: Text('Abilities'))),
    Tab(child: FittedBox(child: Text('Power'))),
  ];

  final VoidCallback refreshList;
  final VoidCallback updateOffset;
  final Future<void> Function() fetchPokemons;
  final List<String> typeFilterArgs;
  final int Function() selectedGeneration;
  final void Function(int) onChangedGeneration;

  const FilterBottomSheetContent({
    super.key,
    required this.fetchPokemons,
    required this.refreshList,
    required this.updateOffset,
    required this.typeFilterArgs,
    required this.selectedGeneration,
    required this.onChangedGeneration,
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
        const FilterBottomSheetHeader(),

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
              ),
              GenerationView(
                selectedGeneration: widget.selectedGeneration,
                onChangedGeneration: widget.onChangedGeneration,
                refreshList: widget.refreshList,
                fetchPokemons: widget.fetchPokemons,
              ),
              const Center(child: Text('Abilities')),
              const Center(child: Text('Power')),
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

  const TypeGridView({
    super.key,
    required this.refreshList,
    required this.fetchPokemons,
    required this.typeFilterArgs,
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

  const GenerationView({
    super.key,
    required this.selectedGeneration,
    required this.onChangedGeneration,
    required this.refreshList,
    required this.fetchPokemons,
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
                        onTap: () => _changeGeneration(generation.id),
                        child: Row(
                          children: [
                            Radio(
                              value: generation.id,
                              groupValue: _currentSelection,
                              onChanged: (_) =>
                                  _changeGeneration(generation.id),
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

class FilterBottomSheetHeader extends StatelessWidget {
  const FilterBottomSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
