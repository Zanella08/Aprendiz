import 'package:aprendiz/telas/Login.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:flutter/material.dart';

class CadastroScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confpasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
          _buildNavigationButton(context, "Já possuo cadastro", LoginScreen()),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader('Cadastro', Icons.person),
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
        Icon(icon, size: 80, color:AppColors.prin1),
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
          _buildTextField('Email', controller: emailController),
          _buildTextField('Senha',
              isPassword: true, controller: passwordController),
          _buildTextField('Confirme sua senha',
              isPassword: true, controller: confpasswordController),
          SizedBox(height: 20),
          _buildButton('Cadastrar', () {
            if (usernameController.text.isEmpty ||
                passwordController.text.isEmpty ||
                emailController.text.isEmpty ||
                confpasswordController.text.isEmpty) {
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
            } else if (passwordController.text != confpasswordController.text) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Inválido'),
                  content: Text('As senhas são diferentes'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            } else if (!emailController.text.contains("@")) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Inválido'),
                  content: Text('Email não contém @'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              Global.username = usernameController.text;
              Global.email = emailController.text;
              Global.password = passwordController.text;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          })
        ],
      ),
    );
  }

  Widget _buildTextField(String label,
      {TextEditingController? controller, bool isPassword = false}) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      border: Border.all(color: AppColors.prin1, width: 2),
      boxShadow: [
        BoxShadow(
          color: AppColors.prin1,
          blurRadius: 5,
          offset: Offset(2, 2),
        ),
      ],
    );
  }
}
