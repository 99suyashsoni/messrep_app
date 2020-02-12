import 'package:flutter/material.dart';
import 'package:messrep_app/login/login_repository.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF49B65),
            Color(0xFFD9492D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _Login(),
        ),
      ),
    );
  }
}

class _Login extends StatefulWidget {
  @override
  State<_Login> createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Spacer(),
        Text(
          'Mess Issues App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 80.0),
        Align(
          alignment: Alignment.center,
          child: RaisedButton(
            child: Text(
              'Login',
              style: TextStyle(fontSize: 20.0),
            ),
            elevation: 2.0,
            textColor: Color(0xFF6B6054),
            color: Color(0xFFFFE0A4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onPressed: () async {
              final repo = Provider.of<LoginRepository>(context);
              try {
                final idToken = await repo.signInWithGoogle();
                setState(() {
                  _isLoading = true;
                });
                await repo.login(idToken);
                Navigator.of(context).pop();
              } on Exception catch (e) {
                print(e.toString());
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
