import 'package:flutter/material.dart';

buildListView() {
  return ListView(children: [
    ListTile(
      //opções de itens possíveis de colocar no ListTitle
      leading: Icon(Icons.person,
          color: Colors.greenAccent), //coloca um ícone no início da linha
      title: Text("Exemplo de título"), //coloca um texto de título
      subtitle: Text("Exemplo de subtítulo"), //coloca um texto de subtítulo
      trailing: Icon(
        Icons.delete,
        color: Colors.redAccent,
      ), //coloca um ícone no final da linha
      onTap: () {
        print("Item 1 selecionado");
      }, //quando clicar irá realizar uma ação
    ),
    ListTile(
      leading: Icon(
        Icons.person,
        color: Colors.greenAccent,
      ),
      title: Text("Exemplo de título"),
      subtitle: Text("Exemplo de subtítulo"),
      trailing: Icon(
        Icons.delete,
        color: Colors.redAccent,
      ),
      onTap: () {
        print("Item 2' selecionado");
      },
    ),
  ]);
}
