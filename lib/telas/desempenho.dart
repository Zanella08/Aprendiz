import 'package:aprendiz/telas/perfil.dart';
import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/Bottomapp.dart';
import 'package:flutter/material.dart';


class TelaDesempenho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.nightMode == true ? AppColors.prin2 : Colors.white,
      bottomNavigationBar: BottomApp(context: context, cor3: AppColors.prin1, ismenu: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Center(
  child: Global.nightMode == false ? Image.asset(
    "assets/imagens/aprendiz-p.png",
    height: 50,
  ): Image.asset(
    "assets/imagens/aprendiz-b.png",
    height: 50,
  ),
),
            SizedBox(height: 20),
            SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Icon(Icons.person_outlined, size: 60, color: appcolor2()),
            SizedBox(width: 10),
            Text(
              Global.username,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: appcolor2(),
              ),
            ),
          ],
        ),
            SizedBox(height: 30),

            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Global.nightMode == false ? AppColors.prin1 : Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Desempenho",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Global.nightMode == false ? AppColors.prin1 : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DesempenhoBarra(nome: "Audição", cor: Colors.red, porcentagem: 1),
                  DesempenhoBarra(nome: "Fala", cor: Colors.lightBlue, porcentagem: 1),
                  DesempenhoBarra(nome: "Assimilação", cor: Colors.amber, porcentagem: 1),
                  DesempenhoBarra(nome: "Memória", cor: Colors.lightGreen, porcentagem: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DesempenhoBarra extends StatelessWidget {
  final String nome;
  final Color cor;
  final double porcentagem;

  const DesempenhoBarra({
    required this.nome,
    required this.cor,
    required this.porcentagem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nome,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Global.nightMode == false ? AppColors.prin1 : Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Stack(
          children: [
            Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Global.nightMode == false ? AppColors.prin1 : Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width * 0.75 * porcentagem,
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    "${(porcentagem * 100).toInt()}%",
                    style: TextStyle(
                      color: Global.nightMode == false ? AppColors.prin1 : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
