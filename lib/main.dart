import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/widgets/modulos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color(AppColors.prin2.value),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: Modulos(),
    );
  }
}
