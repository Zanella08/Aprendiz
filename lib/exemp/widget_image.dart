import 'package:flutter/material.dart';

widgetImage() {
  return SizedBox(
      child: Image.asset(
    "imagens/a.jpg",
    width: 40000,
    height: 700,
    fit: BoxFit.cover,
  ));
}
