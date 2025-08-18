import 'package:aprendiz/telas/Cadastro.dart';
import 'package:aprendiz/telas/Login.dart';
import 'package:aprendiz/telas/desempenho.dart';
import 'package:aprendiz/telas/perfil.dart';
import 'package:aprendiz/transitions/Transicao.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/modulos.dart';
import 'package:flutter/material.dart';

BottomApp({
  required BuildContext context,
  required cor3,
  required bool ismenu,
}) {
  return Container(
    height: 70,
    decoration: BoxDecoration(
      color: cor3,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: BottomAppBar(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed:
                ismenu
                    ? null
                    : () {
                      Transicao(context, Modulos());
                    },
            icon: Icon(Icons.home, color: Colors.white, size: 40),
          ),
          IconButton(
            onPressed: () {
              if (Global.log == 'n') {
                showDialog(
                  context: context,
                  builder: (context) => warning2(context),
                );
                return;
              }else if (Global.modoParental == true) {
                showDialog(
                  context: context,
                  builder: (context) => Global.tentativas >= 3
                      ? warning5Dialog(context)
                      : warning4(context),
                );
                return;
              }
              Transicao(context, TelaDesempenho());
            },
            icon: Icon(Icons.book, color: Colors.white, size: 40),
          ),
          IconButton(
            onPressed: () {
              if (Global.modoParental == true) {
                showDialog(
                  context: context,
                  builder: (context) => Global.tentativas >= 3
                      ? warning5Dialog(context)
                      : warning4(context),
              );
              }else{
                Transicao(
                context,
                Global.log != 's' ? CadastroScreen() : PerfilScreen(),
              );
              }
              
            },
            icon: Icon(Icons.person, color: Colors.white, size: 40),
          ),
        ],
      ),
    ),
  );
}

warning(BuildContext context) {
  return AlertDialog(
    title: Text('Log out'),
    content: Text('Você realmente deseja sair?'),
    actions: [
      TextButton(
        onPressed: () {
          Global.log = '';
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Text('Sim'),
      ),
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Não')),
    ],
  );
}

warning2(BuildContext context) {
  return AlertDialog(
    backgroundColor: AppColors.prin1,
    title: Text(
      'Você não está logado',
      style: TextStyle(color: Colors.white, fontSize: 25),
    ),
    content: Text(
      'Deseja fazer login?',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Text(
          'Sim',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Não',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

warning3(BuildContext context, {int Cor = 0}) {
  return AlertDialog(
    backgroundColor: AppColors.prin1,
    title: Text(
      'Você não está logado',
      style: TextStyle(color: Colors.white, fontSize: 25),
    ),
    content: Text(
      'Nenhum progesso será salvo caso não faça o login. Deseja fazer login?',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Text(
          'Sim',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Não',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
warning4(BuildContext context) {
  TextEditingController codigoparental = TextEditingController();
  return AlertDialog(
    title: Text('Confirmação'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Digite o código parental para confirmação:'),
        SizedBox(height: 10),
        TextField(
          controller: codigoparental,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Código Parental',
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
              codigoparental.text == Global.codigoDesbloqueio) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Modo parental desativado!'),
              ),
            );
            Navigator.pop(context); // Fecha o pop-up
            Global.modoParental = false;  
            Global.tentativas = 0; // Reseta as tentativas
          } else {
            Global.tentativas++;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Código errado.',
                ),
              ),
            );
          
          Navigator.pop(context); // Fecha o pop-up
        }
        },
        child: Text('Continuar'),
      ),
    ],
  );
          }
Widget warning5Dialog(BuildContext context) {
  TextEditingController codigoController = TextEditingController();
  return AlertDialog(
    title: Text('Número de tentativas excedido'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Insira o código para continuar usando o aplicativo:'),
        SizedBox(height: 10),
        TextField(
          controller: codigoController,
          decoration: InputDecoration(
            labelText: 'Código',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          if (codigoController.text == Global.codigoDesbloqueio) {
            Global.bloqueado = false;
            Global.modoParental = false;
            Global.tentativas = 0; // Reseta as tentativas
            Global.inicioUso = DateTime.now();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Modo parental desativado!'),
              ),
            );
          }
        },
        child: Text('Desbloquear'),
      ),
    ],
  );
}

void warning5(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => warning5Dialog(context),
  );
}