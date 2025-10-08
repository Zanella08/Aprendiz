import 'package:aprendiz/telas/Cadastro.dart';
import 'package:aprendiz/telas/perfil.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:aprendiz/widgets/modulos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parental Control',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: CadastroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class ParentalScreen extends StatelessWidget {
  ParentalScreen({super.key});

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
          _buildTextField(
            'Tempo de uso de aplicativo',
            controller: TextEditingController(
              text:
                  Global.tempo.toString() == '0'
                      ? 'Não definido'
                      : Global.tempo.toString() == "1"
                      ? '1 minuto'
                      : '${Global.tempo} minutos',
            ),
          ),
          SizedBox(height: 20),
          _buildButton('Redefinir tempo de uso', () {
            TextEditingController tempoController = TextEditingController(
              // ignore: unnecessary_null_comparison
              text: Global.tempo != null ? Global.tempo.toString() : '',
            );
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Definir Tempo de Uso'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Defina o tempo de uso do aplicativo (em minutos):',
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: tempoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Tempo (minutos)',
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
                          if (tempoController.text.isNotEmpty) {
                            Global.tempo =
                                int.tryParse(tempoController.text) ?? 0;
                          } else {
                            Global.tempo = 0;
                          }
                          Global.inicioUso = DateTime.now();
                          Global.bloqueado = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Global.tempo >= 1
                                    ? 'Tempo de uso definido para ${Global.tempo} minutos.'
                                    : 'Tempo de uso definido para menos de 1 minuto.',
                              ),
                            ),
                          );
                          Navigator.pop(context);
                          Transicao(context, ParentalScreen());
                        },
                        child: Text('Salvar'),
                      ),
                    ],
                  ),
            );
          }),
          SizedBox(height: 20),
          _buildTextField(
            'Código Parental',
            controller: TextEditingController(text: Global.codigoDesbloqueio),
          ),
          _buildButton('Redefinir o código parental', () {
            TextEditingController codigoparental = TextEditingController();
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Redefinir código'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Digite seu novo código:'),
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
                          Navigator.pop(context); // Fecha o pop-up sem salvar
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (codigoparental.text.isNotEmpty &&
                              codigoparental.text != Global.codigoDesbloqueio) {
                            Global.codigoDesbloqueio = codigoparental.text;
                            Navigator.pop(context); // Fecha o pop-up
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Código redefinido com sucesso!'),
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
                          Transicao(context, PerfilScreen());
                        },
                        child: Text('Salvar'),
                      ),
                    ],
                  ),
            );
          }),
          SizedBox(height: 20),
          _buildButton("Ativar o modo parental", () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Redefinir código'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ao confirmar, você ativará o modo parental. \nOnde o aplicativo bloqueará o uso após o tempo definido e bloqueará o acesso a página de perfil e de desempenho.\nCaso não tenha definido um tempo de uso do aplicativo, apenas o acesso as páginas de perfil e desempenho serão bloqueadas. \n\n Deseja continuar?',
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
                          Global.modoParental = true;
                          Transicao(context, Modulos());
                        },
                        child: Text('Salvar'),
                      ),
                    ],
                  ),
            );
          }),
          SizedBox(height: 20),
          _buildButton('Voltar', () {
            Transicao(context, PerfilScreen());
          }),
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
