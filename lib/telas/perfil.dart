import 'package:aprendiz/telas/Cadastro.dart';
import 'package:aprendiz/telas/Login.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: CadastroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class PerfilScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController(
    text: Global.username,
  );
  final TextEditingController emailController = TextEditingController(
    text: Global.email,
  );
  final TextEditingController passwordController = TextEditingController(
    text: Global.password,
  );

  bool _isPasswordVisible = false;

  PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomApp(
        context: context,
        cor3: AppColors.prin1,
        ismenu: false,
      ),
      backgroundColor: appcolor(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(),
              _buildProfileForm(context),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 40),
            SizedBox(
              height: 60,
              child:
                  Global.nightMode == false
                      ? Image.asset(
                        "assets/imagens/aprendiz-p.png",
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        "assets/imagens/aprendiz-b.png",
                        fit: BoxFit.cover,
                      ),
            ),
          ],
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 50),
            Icon(Icons.person_outlined, size: 60, color: appcolor2()),
            SizedBox(width: 10),
            Text(
              Global.username,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: appcolor2(),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          _buildTextField('Nome de Usuário', controller: usernameController),
          _buildTextField('Email', controller: emailController),
          _buildPasswordField(context),
          SizedBox(height: 20),
          _buildButton('Redefinir Senha', () {
            TextEditingController newPasswordController =
                TextEditingController();
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Redefinir Senha'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Digite sua nova senha:'),
                        SizedBox(height: 10),
                        TextField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Nova Senha',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Fecha o pop-up sem salvar
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (newPasswordController.text.isNotEmpty &&
                              newPasswordController.text != Global.password) {
                            Global.password = newPasswordController.text;
                            Navigator.pop(context); // Fecha o pop-up
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Senha redefinida com sucesso!'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Por favor, insira uma nova senha.',
                                ),
                              ),
                            );
                          }
                          Transicao(context, PerfilScreen());
                        },
                        child: Text('Salvar'),
                      ),
                    ],
                  ),
            );
          }),
          SizedBox(height: 20),
          _buildButton('Sair da Conta', () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text("Tem certeza que deseja sair?"),
                    content: Text(
                      "Ao confirmar, você confirma que deseja sair da conta e será redirecionado a tela de Login.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Não"),
                      ),
                      TextButton(
                        onPressed: () => Transicao(context, LoginScreen()),
                        child: Text("Sim"),
                      ),
                    ],
                  ),
            );
          }),
          SizedBox(height: 20),
          _buildButton('Modo Noturno', () {
            if (Global.nightMode == false) {
              Global.nightMode = true;
            } else if (Global.nightMode == true) {
              Global.nightMode = false;
            } else {
              Global.nightMode = false;
            }
            Transicao(context, PerfilScreen());
          }),
        ],
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextField(
        style: TextStyle(
          color: Global.nightMode == false ? Colors.black : Colors.white,
        ),
        controller: passwordController,
        readOnly: true,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Global.nightMode == false ? AppColors.prin2 : Colors.white,
          ),
          labelText: 'Senha',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: Icon(
              color: Global.nightMode == false ? AppColors.prin2 : Colors.white,
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              _isPasswordVisible = !_isPasswordVisible;
              (context as Element).markNeedsBuild(); // Atualiza a tela
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {TextEditingController? controller}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        readOnly: true,
        style: TextStyle(
          color: Global.nightMode == false ? Colors.black : Colors.white,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Global.nightMode == false ? AppColors.prin1 : Colors.white,
          ),
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
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: appcolor(),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: Global.nightMode == false ? AppColors.prin1 : Colors.white,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: appcolor2().withOpacity(0.2),
          blurRadius: 5,
          offset: Offset(2, 2),
        ),
      ],
    );
  }
}

appcolor() {
  return Global.nightMode == false ? Colors.white : AppColors.prin2;
}

appcolor2() {
  return Global.nightMode == false ? AppColors.prin1 : Colors.white;
}

appcolor3() {
  return Global.nightMode == false ? AppColors.prin2 : AppColors.prin1;
}
