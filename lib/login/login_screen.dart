import 'package:flutter/material.dart';
import 'package:messrep_app/login/login_repository.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _Login(),
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

    return RaisedButton(
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
          Navigator.of(context).pop('');
        } on Exception catch (e){
          //display exception or something
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}