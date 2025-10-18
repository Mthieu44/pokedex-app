import 'package:flutter/material.dart';
import 'package:pokedex_app/data/api/pokemon.service.dart';
import 'package:pokedex_app/data/models/pokemon.model.dart';
import 'package:pokedex_app/data/models/pokemon_form.model.dart';
import 'package:pokedex_app/data/models/pokemon_image.model.dart';
import 'package:pokedex_app/data/models/pokemon_species.model.dart';
import 'package:pokedex_app/data/models/pokemon_type.model.dart';
import 'package:pokedex_app/ui/theme/type_colors.theme.dart';
import 'package:pokedex_app/ui/widgets/pokemon_image_bubble.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_stat.widget.dart';
import 'package:pokedex_app/ui/widgets/pokemon_type_bubble.widget.dart';
import 'package:pokedex_app/ui/widgets/type_effectiveness.widget.dart';

class PokemonDetailsPage extends StatefulWidget {
  const PokemonDetailsPage({
    super.key,
    required this.pokemonSpecies,
    this.initialVariantIndex = 0,
    this.initialFormIndex = 0,
  });

  final PokemonSpecies pokemonSpecies;
  final int initialVariantIndex;
  final int initialFormIndex;

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  PokemonService pokemonService = PokemonService.instance;
  bool isShiny = false;
  bool isFavorite = false;
  PokemonImageType imageType = PokemonImageType.animatedSprite3D;
  late int currentVariantIndex;
  late int currentFormIndex;
  Pokemon get currentVariant => widget.pokemonSpecies.variants[currentVariantIndex];
  PokemonForm get currentForm => currentVariant.forms[currentFormIndex];

  Future<void> _fetchForms() async {
    await pokemonService.fetchAllFormsForPokemon(currentVariant);
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    currentVariantIndex = widget.initialVariantIndex;
    currentFormIndex = widget.initialFormIndex;
    _fetchForms();
  }
  void _setVariant(int index) {
    setState(() {
      currentVariantIndex = index;
      currentFormIndex = 0;
    });
    _fetchForms();
  }

  String _lastSwipeDirection = "";

  void _nextForm() {
    setState(() {
      _lastSwipeDirection = "next";
      currentFormIndex = (currentFormIndex + 1) % currentVariant.forms.length;
    });
  }

  void _previousForm() {
    setState(() {
      _lastSwipeDirection = "previous";
      currentFormIndex = (currentFormIndex - 1 + currentVariant.forms.length) % currentVariant.forms.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = TypeColors.getPalette(currentVariant.primaryType.name);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: palette.secondary,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            stretch: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {
                Navigator.pop(context)
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                    isShiny ? Icons.auto_awesome : Icons.auto_awesome_outlined,
                    color: isShiny ? Colors.yellow : Colors.white
                ),
                onPressed: () => {
                  setState(() {
                    isShiny = !isShiny;
                  })
                },
              ),
              IconButton(
                icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: isFavorite ? Colors.red : Colors.white
                ),
                onPressed: () => {
                  setState(() {
                    isFavorite = !isFavorite;
                  })
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onHorizontalDragStart: (_) {},
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! < 0) {
                      _nextForm();
                    } else if (details.primaryVelocity! > 0) {
                      _previousForm();
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        palette.primary,
                        palette.secondary,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.only(top: topPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 150),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              final inFromRight = Tween<Offset>(
                                begin: Offset(1.0, 0.0),
                                end: Offset(0.0, 0.0),
                              ).animate(animation);
                              final inFromLeft = Tween<Offset>(
                                begin: Offset(-1.0, 0.0),
                                end: Offset(0.0, 0.0),
                              ).animate(animation);

                              if (child.key == ValueKey(currentForm.id)) {
                                return SlideTransition(
                                  position: _lastSwipeDirection == "next" ? inFromRight : inFromLeft,
                                  child: FadeTransition(opacity: animation, child: child),
                                );
                              } else {
                                return SlideTransition(
                                  position: _lastSwipeDirection == "next" ? inFromLeft : inFromRight,
                                  child: FadeTransition(opacity: animation, child: child),
                                );
                              }
                            },
                            child: Hero(
                              key: ValueKey(currentForm.id),
                              tag: 'pokemon_image_${widget.pokemonSpecies.id}',
                              child: PokemonImageBubble(
                                pokemonImage: currentForm.images,
                                size: 150,
                                type: isShiny ? imageType.shiny : imageType,
                                zoom: 1.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (currentVariant.forms.length > 1) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              currentVariant.forms.length,
                              (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == currentFormIndex ? Colors.white : Colors.white54,
                                ),
                              )
                            )
                          )
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 4,
                        children: [
                          Text(
                            (widget.pokemonSpecies.variants.length > 1 &&
                              currentVariant.forms.length == 1 &&
                              currentForm.formName != "") ?
                              currentForm.displayFormName : currentVariant.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          if (currentVariant.forms.length > 1) ...[
                            Text(
                              currentForm.displayFormName,
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            )
                          ]
                        ],
                      ),
                      Text(
                        "#${widget.pokemonSpecies.id}",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ), // nom et id
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PokemonTypeBubbleWidget(type: currentVariant.primaryType),
                      if (currentVariant.secondaryType != null) ...[
                        SizedBox(width: 8),
                        PokemonTypeBubbleWidget(
                          type: currentVariant.secondaryType!,
                        ),
                      ],
                    ],
                  ), // types
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                      "Base Stats",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                      "Total: ${currentVariant.stats.total}",
                        style: TextStyle(fontSize: 16, color: Colors.grey)
                      ),
                    ],
                  ), // stats title
                  SizedBox(height: 8),
                  Column(
                    children: [
                      PokemonStatWidget(
                        statName: "HP",
                        statValue: currentVariant.stats.hp,
                      ),
                      PokemonStatWidget(
                        statName: "Attack",
                        statValue: currentVariant.stats.attack,
                      ),
                      PokemonStatWidget(
                        statName: "Defense",
                        statValue: currentVariant.stats.defense,
                      ),
                      PokemonStatWidget(
                        statName: "Sp. Atk",
                        statValue: currentVariant.stats.specialAttack,
                      ),
                      PokemonStatWidget(
                        statName: "Sp. Def",
                        statValue: currentVariant.stats.specialDefense,
                      ),
                      PokemonStatWidget(
                        statName: "Speed",
                        statValue: currentVariant.stats.speed,
                      ),
                    ],
                  ), // stats list
                  SizedBox(height: 16),
                  Text(
                    "Type Effectiveness",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ), // type effectiveness title
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: currentVariant.effectiveness.entries
                        .where((e) => e.value > 1)
                        .map((e) => TypeEffectivenessWidget(type: e.key, effectiveness: e.value))
                        .toList()..sort((a, b) => b.effectiveness.compareTo(a.effectiveness))
                  ), // faiblesses
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: currentVariant.effectiveness.entries
                      .where((e) => e.value < 1 && e.value > 0)
                      .map((e) => TypeEffectivenessWidget(type: e.key, effectiveness: e.value))
                      .toList()..sort((a, b) => b.effectiveness.compareTo(a.effectiveness))
                  ), // resistances
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: currentVariant.effectiveness.entries
                      .where((e) => e.value == 0)
                      .map((e) => TypeEffectivenessWidget(type: e.key, effectiveness: e.value))
                      .toList()
                  ), // immun
                  if (widget.pokemonSpecies.evolutions.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Text(
                      "Evolutions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 4,
                        children: [
                          for (var evo in widget.pokemonSpecies.evolutions) ...[
                            PokemonImageBubble(
                              pokemonImage: evo.getByFormName(currentForm.name).$2.images,
                              size: 75,
                              type: imageType,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ], // evolutions
                  if (widget.pokemonSpecies.preEvolution != null) ...[
                    SizedBox(height: 16),
                    Text(
                      "Pre-Evolution",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    PokemonImageBubble(
                      pokemonImage: widget.pokemonSpecies.preEvolution!.getByFormName(currentForm.name).$2.images,
                      size: 75,
                      type: imageType,
                    ),
                  ], // pre-evolution
                  if (widget.pokemonSpecies.variants.length > 1) ...[
                    SizedBox(height: 16),
                    Text(
                      "Variants",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var variant in widget.pokemonSpecies.variants)
                            if (variant != currentVariant)
                              GestureDetector(
                                onTap: () => _setVariant(widget.pokemonSpecies.variants.indexOf(variant)),
                                child: PokemonImageBubble(
                                  pokemonImage: variant.images,
                                  size: 75,
                                  type: imageType,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ], // variants
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
