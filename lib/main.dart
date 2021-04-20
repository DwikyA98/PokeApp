import 'package:flutter/material.dart';
import 'package:pokeapp_info/PokedexView.dart';
import 'package:pokeapp_info/pokedetail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PokedexView(),
        onGenerateRoute: (RouteSettings settings) {
          Map params = settings.arguments;
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (context) => PokedexView());
              break;
            case '/detail':
              return MaterialPageRoute(
                  builder: (context) => PokemonDetail(
                      id: params['id'],
                      name: params['name'],
                      image: params['image']));
              break;
            default:
              return MaterialPageRoute(builder: (context) => PokedexView());
          }
        });
  }
}
