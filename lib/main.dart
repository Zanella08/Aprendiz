import 'package:aprendiz/telas/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:aprendiz/widgets/modulos.dart';
import 'package:flutter/material.dart';
import 'package:aprendiz/utils/global.dart'; // Importa Global
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    Global.log = 's';
    Global.islogged = true;
    Global.email = user.email ?? '';

    // Busca os dados do usuário no Firestore e vincula às variáveis locais
    final doc =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      Global.username = data['username'] ?? '';
      Global.password = data['password'] ?? '';
      Global.nightMode = data['nightMode'] ?? false;
      Global.codigoDesbloqueio = data['codigoDesbloqueio'] ?? '';
      Global.modoParental = data['modoParental'] ?? false;
      Global.tempo = data['tempo'] ?? 0;
    }
  } else {
    Global.log = 'n';
    Global.islogged = false;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home:
          FirebaseAuth.instance.currentUser != null ? Modulos() : LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
