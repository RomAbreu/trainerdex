import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trainerdex/constants/app_values.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/models/pokemon_ability.dart';
import 'package:trainerdex/models/pokemon_initial_data.dart';
import 'package:trainerdex/models/pokemon_move.dart';
import 'package:trainerdex/models/pokemon_node.dart';
import 'package:trainerdex/utils.dart';
import 'package:trainerdex/repositories/pokemon_details_repository.dart';
import 'package:trainerdex/views/pokemon_details/widgets/background_sliver_app_bar.dart';
import 'package:trainerdex/views/pokemon_details/widgets/pokemon_abilities_container.dart';
import 'package:trainerdex/views/pokemon_details/widgets/pokemon_base_stats.dart';
import 'package:trainerdex/views/pokemon_details/widgets/pokemon_basic_info.dart';
import 'package:trainerdex/views/pokemon_details/widgets/pokemon_evolution_chain.dart';
import 'package:trainerdex/views/pokemon_details/widgets/pokemon_info_container.dart';
import 'package:trainerdex/views/pokemon_details/widgets/pokemon_moves_container.dart';

class PokemonDetailsView extends StatefulWidget {
  final Pokemon pokemon;
  final int option;

  const PokemonDetailsView({super.key, required this.pokemon, this.option = 0});

  @override
  State<PokemonDetailsView> createState() => _PokemonDetailsViewState();
}

class _PokemonDetailsViewState extends State<PokemonDetailsView> {
  String? _flavorText;
  List<PokemonAbility>? _abilities;
  late PokemonDetailsRepository _pokemonDetailsRepository;
  String _selectedVersion = 'scarlet-violet';
  List<PokemonMove>? _moves;
  PokemonNode? _evolutionChain;
  PokemonInitialData _initialData = PokemonInitialData();
  bool _error = false;

  int _selectedPage = 0;
  final animationDuration = const Duration(milliseconds: 200);

  Future<void> _fetchInitialData() async {
    try {
      final initialData =
          await _pokemonDetailsRepository.fetchInitialData(widget.pokemon.id);

      final moves = await _pokemonDetailsRepository.fetchPokemonMoves(
          widget.pokemon.id, _selectedVersion);

      final flavorText = await _pokemonDetailsRepository.fetchPokemonFlavorText(
          widget.pokemon.id, _selectedVersion);

      final abilities = await _pokemonDetailsRepository.fetchPokemonAbilities(
          widget.pokemon.id, _selectedVersion);

      final evolution = await _pokemonDetailsRepository
          .fetchPokemonEvolutions(widget.pokemon.id);

      setState(() {
        _initialData = initialData;
        _flavorText = flavorText;
        _abilities = abilities;
        _moves = moves;
        _evolutionChain = evolution;
        _error = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final client = GraphQLProvider.of(context).value;
    _pokemonDetailsRepository = PokemonDetailsRepository(client: client);

    _fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.lightenColor(widget.pokemon.color),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shadowColor: Utils.darkenColor(widget.pokemon.color, 0.5),
            expandedHeight: 430.0,
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: Utils.formatPokemonName(widget.pokemon),
                    style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Utils.lightenColor(
                        widget.pokemon.color,
                        AppValues.kTextLightenFactor,
                      ),
                    ),
                  ),
                  TextSpan(
                    text:
                        ' #${widget.pokemon.speciesId.toString().padLeft(3, '0')}',
                    style: TextStyle(
                      color: Utils.lightenColor(
                        widget.pokemon.color,
                        AppValues.kTextLightenFactor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            backgroundColor: Utils.lightenColor(
                widget.pokemon.color, AppValues.kAppBarBackgroundLightenFactor),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: BackgroundSliverAppBar(
                pokemon: widget.pokemon,
                option: widget.option,
              ),
            ),
          ),
          if (_error)
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.error_outline_rounded),
                    const SizedBox(height: 8),
                    const Text('An error occurred while fetching data'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _fetchInitialData,
                      child: const Text('Retry'),
                    )
                  ],
                ),
              ),
            )
          else ...[
            if (_selectedPage == 0) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppValues.kSectionLeftRightPadding,
                    AppValues.kSectionTopPadding,
                    AppValues.kSectionLeftRightPadding,
                    AppValues.kSectionBottomPadding,
                  ),
                  child: _gameVersionDropdown(),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: animationDuration,
                  child: Padding(
                    key: ValueKey(_flavorText),
                    padding: const EdgeInsets.fromLTRB(
                      AppValues.kSectionLeftRightPadding,
                      AppValues.kSectionTopPadding,
                      AppValues.kSectionLeftRightPadding,
                      AppValues.kSectionBottomPadding,
                    ),
                    child: _flavorText == null
                        ? _loadingContainer('Description')
                        : PokemonInfoContainer(
                            key: ValueKey(_flavorText),
                            title: 'Description',
                            pokemonColor: widget.pokemon.color,
                            child: Text(
                              _flavorText!.isEmpty
                                  ? '${Utils.formatPokemonName(widget.pokemon)} has no PokéDex entry for this version'
                                  : _flavorText!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: animationDuration,
                  child: Padding(
                    key: ValueKey(_initialData.cry),
                    padding: const EdgeInsets.fromLTRB(
                      AppValues.kSectionLeftRightPadding,
                      AppValues.kSectionTopPadding,
                      AppValues.kSectionLeftRightPadding,
                      AppValues.kSectionBottomPadding,
                    ),
                    child: _initialData.cry == null
                        ? _loadingContainer('Basic Information')
                        : PokemonInfoContainer(
                            title: 'Basic Information',
                            pokemonColor: widget.pokemon.color,
                            child: PokemonBasicInfo(
                              pokemonColor: widget.pokemon.color,
                              height: _initialData.height!,
                              weight: _initialData.weight!,
                              baseExperience: _initialData.baseExperience!,
                              cries: _initialData.cry!,
                            ),
                          ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: animationDuration,
                  child: Padding(
                    key: ValueKey(_abilities),
                    padding: const EdgeInsets.fromLTRB(
                      AppValues.kSectionLeftRightPadding,
                      AppValues.kSectionTopPadding,
                      AppValues.kSectionLeftRightPadding,
                      AppValues.kSectionBottomPadding,
                    ),
                    child: _abilities == null
                        ? _loadingContainer('Abilities')
                        : PokemonInfoContainer(
                            title: 'Abilities',
                            pokemonColor: widget.pokemon.color,
                            child: PokemonAbilitiesContainer(
                                pokemonColor: widget.pokemon.color,
                                abilities: _abilities!),
                          ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: animationDuration,
                  child: Padding(
                    key: ValueKey(_evolutionChain),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.kSectionLeftRightPadding,
                      vertical: AppValues.kDefaultSectionPadding,
                    ),
                    child: _evolutionChain == null
                        ? _loadingContainer('Evolution Chain')
                        : PokemonInfoContainer(
                            title: 'Evolution Chain',
                            pokemonColor: widget.pokemon.color,
                            child: PokemonEvolutionChain(
                              pokemonNode: _evolutionChain!,
                              pokemonId: widget.pokemon.id,
                              option: widget.option,
                            ),
                          ),
                  ),
                ),
              ),
            ] else if (_selectedPage == 1) ...[
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: animationDuration,
                  child: Padding(
                    key: ValueKey(_initialData.stats),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.kSectionLeftRightPadding,
                      vertical: AppValues.kDefaultSectionPadding,
                    ),
                    child: _initialData.stats == null
                        ? _loadingContainer('Base Stats')
                        : PokemonInfoContainer(
                            title: 'Base Stats',
                            pokemonColor: widget.pokemon.color,
                            child: PokemonBaseStats(
                              pokemonColor: widget.pokemon.color,
                              stats: _initialData.stats!,
                            ),
                          ),
                  ),
                ),
              ),
            ] else ...[
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: animationDuration,
                  child: Padding(
                    key: ValueKey(_moves),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.kSectionLeftRightPadding,
                      vertical: AppValues.kDefaultSectionPadding,
                    ),
                    child: _moves == null
                        ? _loadingContainer('Moves')
                        : PokemonInfoContainer(
                            title: 'Moves',
                            pokemonColor: widget.pokemon.color,
                            child: PokemonMovesContainer(
                              pokemonColor: widget.pokemon.color,
                              moves: _moves!,
                            ),
                          ),
                  ),
                ),
              ),
            ]
          ]
        ],
      ),
      bottomNavigationBar: Container(
        color: Utils.lightenColor(
          widget.pokemon.color,
          AppValues.kAppBarBackgroundLightenFactor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.kBottomNavBarHorizontalPadding,
            vertical: AppValues.kBottomNavBarVerticalPadding,
          ),
          child: GNav(
            selectedIndex: _selectedPage,
            onTabChange: (index) {
              setState(() {
                _selectedPage = index;
              });
            },
            backgroundColor: Utils.lightenColor(
              widget.pokemon.color,
              AppValues.kAppBarBackgroundLightenFactor,
            ),
            color: Colors.black45,
            tabBackgroundColor: Utils.lightenColor(widget.pokemon.color, 0.45),
            padding: const EdgeInsets.all(16),
            gap: 8,
            tabs: [
              const GButton(
                icon: Icons.info_outline_rounded,
                text: 'Info',
              ),
              const GButton(
                icon: Icons.bar_chart_rounded,
                text: 'Stats',
              ),
              GButton(
                icon: MdiIcons.shieldSwordOutline,
                text: 'Moves',
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _gameVersionDropdown() {
    return Row(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              top: gameVersionDropdownBorderStyle(),
              left: gameVersionDropdownBorderStyle(),
              bottom: gameVersionDropdownBorderStyle(),
            ),
            color: Utils.darkenColor(widget.pokemon.color, 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Game Version',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Utils.lightenColor(
                    widget.pokemon.color,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: gameVersionDropdownBorderStyle(),
                right: gameVersionDropdownBorderStyle(),
                bottom: gameVersionDropdownBorderStyle(),
              ),
              color: Utils.lightenColor(widget.pokemon.color, 0.6),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                padding: const EdgeInsets.only(left: 12),
                dropdownColor: Utils.lightenColor(widget.pokemon.color, 0.6),
                value: _selectedVersion,
                onChanged: _gameVersionChanged,
                items: _buildVersionGroupDropdownItems(),
              ),
            ),
          ),
        )
      ],
    );
  }

  BorderSide gameVersionDropdownBorderStyle() {
    return BorderSide(
      color: Utils.darkenColor(widget.pokemon.color, 0.1),
      width: 1.0,
    );
  }

  void _gameVersionChanged(String? value) async {
    setState(() {
      _flavorText = null;
      _selectedVersion = value!;
    });

    try {
      final flavorText = await _pokemonDetailsRepository.fetchPokemonFlavorText(
        widget.pokemon.id,
        _selectedVersion,
      );

      final moves = await _pokemonDetailsRepository.fetchPokemonMoves(
        widget.pokemon.id,
        _selectedVersion,
      );

      setState(() {
        _flavorText = flavorText;
        _moves = moves;
        _error = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  List<DropdownMenuItem<String>> _buildVersionGroupDropdownItems() {
    return AppValues.versionGroupMap.entries
        .map((entry) => DropdownMenuItem(
              value: entry.key,
              child: Text(
                entry.value,
                style: TextStyle(
                  color: Utils.darkenColor(widget.pokemon.color, 0.5),
                  fontSize: entry.value.length > 24 ? 10 : 12,
                  fontWeight: FontWeight.w800,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                ),
              ),
            ))
        .toList();
  }

  Widget _loadingContainer(String title) {
    return PokemonInfoContainer(
      title: title,
      pokemonColor: widget.pokemon.color,
      child: Center(
        child: CircularProgressIndicator(
          color: widget.pokemon.color,
        ),
      ),
    );
  }
}
