import 'package:aprendiz/utils/Style.dart';
import 'package:aprendiz/utils/global.dart';
import 'package:aprendiz/widgets/modulo.dart' as custom;
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _expandedIndex = -1;

  void _toggleContainer(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.nightMode == true
          ? AppColors.prin2
          : AppColors.prin1,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_expandedIndex == -1) ...[
            Container(
                height: 50,
                width: 180,
                decoration: BoxDecoration(
                  color: Global.nightMode == true
          ? AppColors.prin1
          : AppColors.prin2,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    "Atividades",
                    style: AppText.baseg,
                  ),
                )),
            SizedBox(
              height: 20,
            )
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              custom.modulo(
                  expandedIndex: _expandedIndex,
                  toggleContainer: _toggleContainer,
                  image: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/icons/Audi.png", fit: BoxFit.cover),
                  ),
                  titulo: "Audição",
                  cor: Color(AppColors.v1.value),
                  cor2: Color(AppColors.v2.value),
                  cor3: 1,
                  context: context,
                  descricao:
                      "Atividades que irão estimular a audição da criança, criando cenários onde a criança irá ouvir uma situação e irá realizar uma atividade específica"),
              SizedBox(
                width: 20,
              ),
              custom.modulo(
                  expandedIndex: _expandedIndex,
                  toggleContainer: _toggleContainer,
                  image: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/icons/Fala.png", fit: BoxFit.cover),
                  ),
                  titulo: "Fala",
                  cor: Color(AppColors.b1.value),
                  cor2: Color(AppColors.b2.value),
                  cor3: 2,
                  context: context,
                  descricao:
                      "Atividades que irão estimular a fala da criança, criando cenários onde a criança irá utilizar a fala em uma atividade específica."
                      ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              custom.modulo(
                  expandedIndex: _expandedIndex,
                  toggleContainer: _toggleContainer,
                  image: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/icons/Assim.png", fit: BoxFit.cover),
                  ),
                  titulo: "Assimilação",
                  cor: Color(AppColors.y1.value),
                  cor2: Color(AppColors.y2.value),
                  cor3: 3,
                  context: context,
                  descricao:
                      "Atividades que irão estimular a assimilação da criança, criando cenários onde a criança deverá assimilar informações de acordo com o cenário criado."),
              SizedBox(
                width: 20,
              ),
              custom.modulo(
                  expandedIndex: _expandedIndex,
                  toggleContainer: _toggleContainer,
                  image: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/icons/Memo.png", fit: BoxFit.cover),
                  ),
                  titulo: "Memória",
                  cor: Color(AppColors.g1.value),
                  cor2: Color(AppColors.g2.value),
                  cor3: 4,
                  context: context,
                  descricao:
                      "Atividades que irão estimular a memória da criança, criando cenários onde a criança deverá memorizar um cenário e deverá realizar uma atividade relacionada."),
            ],
          ),
        ],
      ),
    );
  }
}
