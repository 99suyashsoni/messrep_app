import 'package:flutter/material.dart';
import 'package:messrep_app/login/login_repository.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [
            Color(0xFFF49B65),
            Color(0xFFD9492D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: Color(0x6EDD5435),
              offset: Offset(3.0, 8.0),
              blurRadius: 10.0),
        ],
      ),
      child: Scaffold(
        body: SafeArea(
          child: _Login(),
        ),
      ),
    );
  }
}

class _Login extends StatefulWidget{
  @override
  State<_Login> createState() => _LoginState();
}

class _LoginState extends State<_Login>{

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      return Center(child: CircularProgressIndicator());
    }

    return Align(
      alignment: Alignment.center,
      child: RaisedButton(
        child: Text('Login'),
        elevation: 2.0,
        onPressed: () async {
          final repo = Provider.of<LoginRepository>(context);
          try{
            final idToken = await repo.signInWithGoogle();
            setState(() {
              _isLoading = true;
            });
            await repo.login(idToken);
            Navigator.of(context).pop();
          } on Exception catch (e){
            print(e.toString());
            setState(() {
              _isLoading = false;
            });
          }
        },
      ),
    );
  }
}