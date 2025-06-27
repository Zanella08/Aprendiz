import 'package:aprendiz/telas/Cadastro.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/modulos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: CadastroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatelessWidget {
  // Controladores para os campos de texto
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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
          _buildTextField('Nome de usuário', controller: usernameController),
          _buildTextField('Senha',
              isPassword: true, controller: passwordController),
          SizedBox(height: 20),
          _buildButton('Entrar', () {
            // Verificação dos campos
            if (usernameController.text.isEmpty &&
                passwordController.text.isEmpty) {
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
            } else {
              if (usernameController.text != Global.username &&
                  passwordController.text != Global.password) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Inválido'),
                    content: Text('Nome de usuário e senha incorretos.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              } else if (usernameController.text != Global.username) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Inválido'),
                    content: Text('Nome de usuário incorreto.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              } else if (passwordController.text != Global.password) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Inválido'),
                    content: Text('Senha incorreta.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                Global.log = 's';
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Modulos()),
                );
              }
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
