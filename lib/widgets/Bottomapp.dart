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
              }
              Transicao(context, TelaDesempenho());
            },
            icon: Icon(Icons.book, color: Colors.white, size: 40),
          ),
          IconButton(
            onPressed: () {
              Transicao(
                context,
                Global.log != 's' ? CadastroScreen() : PerfilScreen(),
              );
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
