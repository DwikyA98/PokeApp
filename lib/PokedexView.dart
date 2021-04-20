import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';
import 'package:pokeapp_info/Data/Pokemon.dart';
import 'package:pokeapp_info/pokecard.dart';
import 'package:pokeapp_info/url.dart';

import 'Data/PokeAPI.dart';

class PokedexView extends StatefulWidget {
  const PokedexView({Key key}) : super(key: key);

  @override
  _PokedexViewState createState() => _PokedexViewState();
}

class _PokedexViewState extends State<PokedexView> {
  KtList<Pokemon> _pokemonList = emptyList();
  KtList<Pokemon> _filteredpokemon = emptyList();
  bool _isLoading = false;
  final ScrollController _scrollController =
      ScrollController(debugLabel: 'pokemonSc');
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();

    _scrollController.addListener(() {
      if (!_isLoading && _scrollController.position.extentAfter == 0.0) {
        _fetchPokemonList();
      }
    });
  }

  _fetchPokemonList() async {
    setState(() {
      _isLoading = true;
    });
    final pokemonList = await pokeApi.getPokemonList(_pokemonList.size);
    final filteredpokemon = await pokeApi.getPokemonList(_filteredpokemon.size);
    setState(() {
      _pokemonList = _pokemonList.plus(pokemonList);
      _filteredpokemon = _filteredpokemon.plus(filteredpokemon);
      _isLoading = false;
    });
  }

  void filterpokemon(value) {
    setState(() {
      _filteredpokemon = _pokemonList
          .filter((pokemon) => pokemon.name.contains(value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: !isSearching
                  ? Text("Pokedex")
                  : TextField(
                      onChanged: (value) {
                        filterpokemon(value);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search Pokemon Here",
                          hintStyle: TextStyle(color: Colors.white))),
              actions: <Widget>[
                isSearching
                    ? IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            this.isSearching = false;
                            _filteredpokemon = _pokemonList;
                          });
                        })
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            this.isSearching = true;
                          });
                        }),
              ],
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverGrid(
                  delegate: SliverChildBuilderDelegate((ctx, index) {
                    var item = _filteredpokemon[index];
                    return PokemonCard(
                        id: item.id.toString(),
                        image: getPokemonImage(item.id),
                        color: item.color,
                        key: ValueKey(item.id),
                        onTap: () {
                          Navigator.pushNamed(context, '/detail', arguments: {
                            'id': item.id,
                            'name': item.name,
                            'image': getPokemonImage(item.id)
                          });
                        });
                  }, childCount: _filteredpokemon.size),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                ),
                SliverToBoxAdapter(
                    child: _isLoading
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox())
              ],
            )));
  }
}
