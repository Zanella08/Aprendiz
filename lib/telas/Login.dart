import 'package:aprendiz/telas/Cadastro.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/modulos.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildNavigationButton(
        context,
        'Criar uma conta',
        CadastroScreen(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader('Login', Icons.lock),
              _buildForm(context),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Column(
      children: [
        SizedBox(
            height: 70,
            child: Image.asset(
              "assets/imagens/aprendiz-p.png",
              fit: BoxFit.cover,
            )),
        SizedBox(height: 20),
        Icon(icon, size: 80, color: AppColors.prin1),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.prin1,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          _buildTextField('Email ou nome de usuário', controller: usernameController),
          _buildTextField('Senha', isPassword: true, controller: passwordController),
          SizedBox(height: 20),
          _buildButton('Entrar', () async {
            String loginInput = usernameController.text.trim().toLowerCase();
            String passwordInput = passwordController.text;

            if (loginInput.isEmpty || passwordInput.isEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Inválido'),
                  content: Text('Por favor, preencha todos os campos'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
              return;
            }

            String emailToUse = loginInput;
            try {
              // Se não for email, procura pelo nome de usuário no Firestore
              if (!loginInput.contains('@')) {
                var userQuery = await FirebaseFirestore.instance
                    .collection('usuarios')
                    .where('username', isEqualTo: loginInput)
                    .limit(1)
                    .get();

                if (userQuery.docs.isEmpty) {
                  await _mostrarErro(context, loginInput, passwordInput, 'username');
                  return;
                }
                emailToUse = userQuery.docs.first['email'];
              }

              // Autentica com Firebase Auth
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailToUse,
                password: passwordInput,
              );

              Global.log = "s";
              Global.islogged = true;
              Global.username = loginInput;
              Global.password = passwordInput;
              Global.email = emailToUse;

              // Atualiza status no Firestore
              await FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({'islogged': true});

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Modulos()),
              );
            } catch (e) {
              await _mostrarErro(context, loginInput, passwordInput, e);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTextField(String label,
      {bool isPassword = false, TextEditingController? controller}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.prin1,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String text,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        child: Container(
          padding: EdgeInsets.all(20),
          color: AppColors.prin1,
          width: double.infinity,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.purple, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.purple.shade200,
          blurRadius: 5,
          offset: Offset(2, 2),
        ),
      ],
    );
  }
}

// Funções auxiliares para verificar existência de usuário/email
Future<bool> _usuarioExiste(String username) async {
  var userQuery = await FirebaseFirestore.instance
      .collection('usuarios')
      .where('username', isEqualTo: username)
      .limit(1)
      .get();
  return userQuery.docs.isNotEmpty;
}

Future<bool> _emailExiste(String email) async {
  var userQuery = await FirebaseFirestore.instance
      .collection('usuarios')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();
  return userQuery.docs.isNotEmpty;
}

// Função para mostrar erro detalhado
Future<void> _mostrarErro(BuildContext context, String loginInput, String passwordInput, dynamic error) async {
  String mensagem = 'Falha no login';

  if (error == 'username') {
    mensagem = 'Nome de usuário não encontrado';
  } else if (error is FirebaseAuthException && error.code == 'wrong-password') {
    mensagem = 'Senha incorreta';
  } else if (error is FirebaseAuthException && error.code == 'user-not-found') {
    mensagem = loginInput.contains('@') ? 'Email não encontrado' : 'Nome de usuário não encontrado';
  } else {
    // Verifica se o usuário existe para detalhar o erro
    bool usuarioExiste = loginInput.contains('@')
        ? await _emailExiste(loginInput)
        : await _usuarioExiste(loginInput);

    if (!usuarioExiste) {
      mensagem = loginInput.contains('@') ? 'Email não encontrado' : 'Nome de usuário não encontrado';
    } else {
      mensagem = 'Senha incorreta';
    }
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Erro'),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}