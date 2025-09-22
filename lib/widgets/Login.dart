import 'package:aprendiz/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class widgetLogin extends StatefulWidget {
  @override
  State<widgetLogin> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<widgetLogin> {
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20);

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    String loginInput = loginController.text.trim();
    String passwordInput = passwordController.text;

    try {
      String emailToUse = loginInput;

      // Se não for email, procura pelo nome de usuário no Firestore
      if (!loginInput.contains('@')) {
  var userQuery = await FirebaseFirestore.instance
      .collection('usuarios')
      .where('username', isEqualTo: loginInput)
      .limit(1)
      .get();

  if (userQuery.docs.isEmpty) {
    throw Exception('Usuário não encontrado');
  }
  emailToUse = userQuery.docs.first['email'];
}

      // Autentica com Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailToUse,
        password: passwordInput,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sucesso'),
          content: Text('Login realizado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Global.log = "s";
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Falha no login: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: loginController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email ou nome de usuário",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Senha",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
    final buttonLogin = ButtonTheme(
        child: ElevatedButton(
            onPressed: _login,
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Color.fromARGB(255, 12, 122, 165),
                    fontWeight: FontWeight.bold)),
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(400, 50)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
            )));
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                Image.asset("imagens/1.png", width: 250, height: 250),
                SizedBox(height: 0),
                emailField,
                SizedBox(height: 30),
                passwordField,
                SizedBox(height: 30),
                buttonLogin,
              ],
            ),
          ),
        ),
      ),
    );
  }
}