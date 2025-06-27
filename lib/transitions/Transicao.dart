import 'package:flutter/material.dart';

void Transicao(BuildContext context, Widget novaTela) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (_, __, ___) => novaTela,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}
