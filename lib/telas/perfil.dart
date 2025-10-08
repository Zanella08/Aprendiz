import 'package:aprendiz/telas/Login.dart';
import 'package:aprendiz/telas/parental.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatefulWidget {
  PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          usernameController.text = data['username'] ?? '';
          emailController.text = data['email'] ?? '';
          passwordController.text = data['password'] ?? '';
        });
      }
    }
  }

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
              usernameController.text,
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
          SizedBox(height: 20),
          _buildTextField('Email', controller: emailController),
          SizedBox(height: 20),
          ExpansionTile(
            title: Text(
              'Opções de Conta',
              style: TextStyle(
                fontSize: 18,
                color: Global.nightMode ? Colors.white : AppColors.prin1,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              _buildButton('Redefinir Senha', () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && user.email != null) {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: user.email!,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Email de redefinição de senha enviado para ${user.email}!',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Não foi possível enviar o email de redefinição.',
                      ),
                    ),
                  );
                }
              }),
              SizedBox(height: 10),
              _buildButton('Modo Noturno', () {
                Global.nightMode = !Global.nightMode;
                Transicao(context, PerfilScreen());
              }),
              SizedBox(height: 10),
              _buildButton('Menu parental', () {
                if (Global.codigoDesbloqueio.isEmpty) {
                  TextEditingController codigoparental =
                      TextEditingController();
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Defina o Código Parental'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Para continuar a controlar o uso do aplicativo, você precisa definir o código parental.',
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: codigoparental,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Novo Código Parental',
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
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (codigoparental.text.isNotEmpty &&
                                    codigoparental.text !=
                                        Global.codigoDesbloqueio) {
                                  Global.codigoDesbloqueio =
                                      codigoparental.text;
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Código definido com sucesso!',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Por favor, insira um código novo.',
                                      ),
                                    ),
                                  );
                                }
                                Transicao(context, ParentalScreen());
                              },
                              child: Text('Salvar'),
                            ),
                          ],
                        ),
                  );
                } else {
                  Transicao(context, ParentalScreen());
                }
              }),
              SizedBox(height: 10),
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
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({'islogged': false});
                              await FirebaseAuth.instance.signOut();
                              Transicao(context, LoginScreen());
                            },
                            child: Text("Sim"),
                          ),
                        ],
                      ),
                );
              }),
              SizedBox(height: 10),
            ],
          ),
        ],
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
