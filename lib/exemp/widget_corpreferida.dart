import 'package:flutter/material.dart';

class widgetCorPreferida extends StatefulWidget {
  @override
  State<widgetCorPreferida> createState() => _widgetCorPreferidaState();
}

class _widgetCorPreferidaState extends State<widgetCorPreferida> {
  String nomeCor = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statefull Widget"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        color: Colors.grey,
        child: Column(
          children: [
            TextField(
              onSubmitted: (String texto) {
                setState(() {
                  nomeCor = texto;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text("A sua cor preferida é: $nomeCor",
                  style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
      ),
    );
  }
}
