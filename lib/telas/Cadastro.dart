import 'package:aprendiz/telas/Login.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      bottomNavigationBar: _buildNavigationButton(
        context,
        "Já possuo cadastro",
        LoginScreen(),
      ),
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
          ),
        ),
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
          _buildTextField('Email', controller: emailController),
          _buildTextField(
            'Senha',
            isPassword: true,
            controller: passwordController,
          ),
          _buildTextField(
            'Confirme sua senha',
            isPassword: true,
            controller: confpasswordController,
          ),
          SizedBox(height: 20),
          _buildButton('Cadastrar', () async {
            String username = usernameController.text.trim().toLowerCase();
            String email = emailController.text.trim();
            String password = passwordController.text;
            String confPassword = confpasswordController.text;
            String nome = nameController.text.trim();

            String mensagemErro = "";

            if (username.isEmpty ||
                email.isEmpty ||
                password.isEmpty ||
                confPassword.isEmpty) {
              mensagemErro = "Por favor, preencha todos os campos.";
            } else if (!email.contains("@") ||
                !email.contains(".") ||
                email.length < 6) {
              mensagemErro = "Email inválido.";
            } else if (password.length < 6) {
              mensagemErro = "A senha deve ter pelo menos 6 caracteres.";
            } else if (password != confPassword) {
              mensagemErro = "As senhas são diferentes.";
            } else {
              // Verifica se o email já está cadastrado
              var emailQuery =
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('email', isEqualTo: email)
                      .limit(1)
                      .get();
              if (emailQuery.docs.isNotEmpty) {
                mensagemErro = "Este email já está cadastrado.";
              }
              // Verifica se o nome de usuário já está cadastrado
              var userQuery =
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('username', isEqualTo: username)
                      .limit(1)
                      .get();
              if (userQuery.docs.isNotEmpty) {
                mensagemErro = "Este nome de usuário já está cadastrado.";
              }
            }

            if (mensagemErro.isNotEmpty) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Erro'),
                      content: Text(mensagemErro),
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

            try {
              // Cria usuário no Firebase Auth
              UserCredential userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

              // Salva dados adicionais no Firestore
              await FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(userCredential.user!.uid)
                  .set({'username': username, 'email': email, 'nome': nome});

              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Sucesso'),
                      content: Text('Cadastro realizado com sucesso!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
              );
            } catch (e) {
              String erroMsg = "Falha ao cadastrar.";
              if (e is FirebaseAuthException) {
                if (e.code == 'email-already-in-use') {
                  erroMsg = "Este email já está cadastrado.";
                } else if (e.code == 'invalid-email') {
                  erroMsg = "Email inválido.";
                } else if (e.code == 'weak-password') {
                  erroMsg = "A senha é muito fraca.";
                }
              }
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Erro'),
                      content: Text(erroMsg),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    TextEditingController? controller,
    bool isPassword = false,
  }) {
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
        BoxShadow(color: AppColors.prin1, blurRadius: 5, offset: Offset(2, 2)),
      ],
    );
  }
}
