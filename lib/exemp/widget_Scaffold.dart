import 'package:flutter/material.dart';

widgetScaffold() {
  return Scaffold(
    appBar: AppBar(
      title: Text("Curso de Flutter"),
      centerTitle: true,
    ),
    body: Container(
      color: Colors.amber,
    ),
    drawer: Container(
      color: Colors.amberAccent,
      width: 400,
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        print("Cliquei no botão");
      },
    ),
    bottomNavigationBar: BottomAppBar(
      color: Colors.yellow,
      child: Container(
        height: 40,
        child: Row(
          children: [
            Text(
              'Meu BottomThing',
            )
          ],
        ),
      ),
    ),
    persistentFooterButtons: [
      IconButton(onPressed: null, icon: Icon(Icons.ac_unit))
    ],
  );
}
