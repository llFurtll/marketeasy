import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketeasy/views/lista_produtos.dart';
import 'helpers/helper_auth.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    theme: ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        enabledBorder: UnderlineInputBorder(      
          borderSide: BorderSide(color: Colors.white),   
        ), 
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.white,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
      primaryColor: Color.fromRGBO(255, 99, 132, 1),
    ),
  ),
);

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  /* Chave para controle do fomulário */
  final _formKey = GlobalKey<FormState>();
  /* Contrlador do input do usuario */
  final _usuario = TextEditingController();
  /* Controlador do input da senha */
  final _senha = TextEditingController();

  var _showPassword = true;

  var _iconPassword = Icons.remove_red_eye;

  @override
  void initState() {
    /* Deixara tela full Screen */
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildTop(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _buildTop() {
    return Positioned(
      top: 0.0,
      height: MediaQuery.of(context).size.height / 2.1,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(227, 79, 110, 1.0),
          image: DecorationImage(
            image: AssetImage("assets/logo.webp"),
            scale: 0.70,
            alignment: Alignment.center,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 70.0, left: 30.0),
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _usuario,
            // ignore: missing_return
            validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor digite seu usuário';
                }
              },
            decoration: InputDecoration(
              labelText: "Usuários",
              prefixIcon: Icon(Icons.person, color: Colors.white),
            ),
            style: TextStyle(color: Colors.white)
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
            child: TextFormField(
              obscureText: _showPassword,
              controller: _senha,
              style: TextStyle(color: Colors.white),
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor digite a senha';
                }
              },
              decoration: InputDecoration(
                labelText: "Senha",
                prefixIcon: IconButton(
                  icon: Icon(_iconPassword, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if(_showPassword) {
                        _showPassword = false;
                        _iconPassword = Icons.lock;
                      } else {
                        _showPassword = true;
                        _iconPassword = Icons.remove_red_eye_rounded;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if ( _formKey.currentState.validate() ) {
                if ( await validateAuth(_usuario.text, _senha.text) ) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Lista()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Usuário não encontrado", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Color.fromRGBO(252, 214, 98, 1),
                    action: SnackBarAction(
                      label: "Fechar",
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ));
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                  "Entrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Positioned(
      bottom: 0.0,
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.height / 100) * 60,
      child: GestureDetector(
        onTap: () {
          /* Caso o usuário clique fora do formulario, retira o foco e deixa a tela novamente em Full Screen */
          FocusScope.of(context).requestFocus(new FocusNode());
          SystemChrome.setEnabledSystemUIOverlays([]);
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.all(35.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(245, 44, 86, 1),
                Color.fromRGBO(251, 120, 149, 1)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(62.0),
              topRight: Radius.circular(62.0),
            ),
          ),
          child: _buildForm(),
        ),
      ),
    );
  }
}