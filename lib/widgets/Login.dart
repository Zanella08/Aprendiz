import 'package:flutter/material.dart';

class widgetLogin extends StatefulWidget {
  @override
  State<widgetLogin> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<widgetLogin> {
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20);
  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Senha",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
    final buttonLogin = ButtonTheme(
        child: ElevatedButton(
            onPressed: () {},
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Color.fromARGB(255, 12, 122, 165),
                    fontWeight: FontWeight.bold)),
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(400, 50)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
            )));
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                Image.asset("imagens/1.png", width: 250, height: 250),
                SizedBox(
                  height: 0,
                ),
                emailField,
                SizedBox(
                  height: 30,
                ),
                passwordField,
                SizedBox(
                  height: 30,
                ),
                buttonLogin,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
