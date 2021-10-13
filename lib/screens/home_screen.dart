import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en Cines'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView( //* Posibilidad de hacer Scroll
        child: Column(
          children: const <Widget>[
            /* Tarjetas principales */
            CardSwiper(),
            /* Slider de peliculas */
            MovieSlider()
          ],
        ),
      ),
    );
  }
}
