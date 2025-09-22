import 'package:aprendiz/telas/Login.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:aprendiz/widgets/modulos.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: FirebaseAuth.instance.currentUser != null
          ? Modulos() // Usuário já logado, vai direto para Modulos
          : LoginScreen(), // Senão, mostra tela de login
      debugShowCheckedModeBanner: false,
    );
  }
}
