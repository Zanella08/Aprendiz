import 'package:flutter/material.dart';

buildListView2() {
  final itens = List<String>.generate(50, (i) => "Item $i");
  return ListView.builder(
      itemCount: itens.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.person, color: Colors.greenAccent),
          title: Text("Usuário ${index + 1}"),
          trailing: Icon(Icons.delete, color: Colors.redAccent),
          onTap: () {
            debugPrint("Usuário ${index + 1} selecionado");
          },
        );
      });
}
