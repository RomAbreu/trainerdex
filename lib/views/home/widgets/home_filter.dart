import 'package:flutter/material.dart';
import 'package:trainerdex/constants/pokemon_types_util.dart';

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

  const FilterBottomSheetContent({
    super.key,
    required this.fetchPokemons,
    required this.refreshList,
    required this.updateOffset,
    required this.typeFilterArgs,
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
              const Center(child: Text('Generation')),
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
