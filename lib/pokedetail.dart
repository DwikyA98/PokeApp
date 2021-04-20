import 'package:flutter/material.dart';
import 'package:pokeapp_info/Data/PokeAPI.dart';
import 'package:pokeapp_info/Data/PokeDetails.dart';

// ignore: must_be_immutable
class PokemonDetail extends StatefulWidget {
  String id;
  String name;
  String image;
  List<Type> type;
  int weight;
  int height;
  PokemonDetail(
      {this.id, this.name, this.image, this.height, this.weight, this.type});
  @override
  _PokemonDetailState createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  PokeDetails pokemonDetail;

  @override
  void initState() {
    super.initState();
    _getPokemonDetail();
  }

  _getPokemonDetail() async {
    final PokeDetails pokemonResult =
        await pokeApi.getPokemonDetail(widget.name);
    setState(() {
      pokemonDetail = pokemonResult;
    });
  }

  List<Widget> _buildPokemonProfile() {
    return [Text(pokemonDetail.name)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
                child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 75.0),
                            Hero(
                              tag: 'pokemon-${widget.id}',
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.image),
                              ),
                            ),
                            Text(
                              "Types: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: widget.type
                                  .map((t) => FilterChip(
                                      backgroundColor: Colors.amber,
                                      label: Text(t.name),
                                      onSelected: (b) {}))
                                  .toList(),
                            ),
                            Text("Height: ${widget.height}"),
                            Text("Weight: ${widget.weight}"),
                            if (pokemonDetail == null)
                              CircularProgressIndicator(),
                            if (pokemonDetail != null) ..._buildPokemonProfile()
                          ],
                        ),
                      ))),
            )),
            Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: widget.image,
                  child: Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.image),
                        ),
                      )),
                ))
          ],
        ));
  }
}
