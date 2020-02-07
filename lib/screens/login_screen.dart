import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _keyScaffod = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _keyScaffod,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CRIAR LOGIN",
                style: TextStyle(
                    fontSize: 15.0
                ),
              ),
              textColor: Colors.white,
              onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => SingupScreen()
                    )
                );
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model){
              if(model.isLoading)
                return Center(child: CircularProgressIndicator(),);

              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text){
                        if(text.isEmpty || !text.contains("@")) {
                          return "Email invalido.";
                        }
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,
                      validator: (text) {
                        if(text.isEmpty || text.length < 6) return "Senha invalida.";
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                        onPressed: () {
                          if(_emailController.text.isEmpty)
                            _showSnackBar("Inserir o seu e-mail para recuperação", Colors.red);
                          else {
                            model.recoverPass(_emailController.text);
                            _showSnackBar("Confira seu e-mail.", Theme.of(context).primaryColor);
                          }
                        },
                        child: Text("Esqueci minha senha",
                          textAlign: TextAlign.right,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 16.0,),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if(_formKey.currentState.validate()){

                          }

                          model.singIn(email: _emailController.text, pass: _passController.text, onSucess: _onSucess, onFaild: _onFaild);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
        )
    );
  }

  void _onSucess(){
    Navigator.of(context).pop();
  }

  void _onFaild(){
    _showSnackBar("falha ao entrar.", Colors.red);
  }
  void _showSnackBar(String msg, Color cor){
    _keyScaffod.currentState.showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(seconds: 2),
          backgroundColor: cor,
        )
    );
  }
}
