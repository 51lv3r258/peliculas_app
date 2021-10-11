import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en Cines'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
