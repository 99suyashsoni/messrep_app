import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messrep_app/issues/issue_notifier.dart';
import 'package:messrep_app/issues/issues_repository.dart';
import 'package:messrep_app/issues/issues_screen.dart';
import 'package:messrep_app/login/login_repository.dart';
import 'package:messrep_app/login/login_screen.dart';
import 'package:messrep_app/util/database_helper.dart';
import 'package:messrep_app/util/network_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZoned(() async {
    final prefs = await SharedPreferences.getInstance();
    final database = await databaseInstance('messrep.db');
    final client = NetworkClient(
      baseUrl: 'http://142.93.213.45/api',
      headers: {'Content-Type': 'application/json'},
    );

    final loginRepository = LoginRepository(
      preferences: prefs,
      client: client,
    );

    final issuesRepository = IssuesRepository(
      database: database,
      client: client,
    );

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(0xFF5A534A)));

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (prefs.containsKey('JWT')) {
      client.headers.addAll({'Authorization': prefs.getString('JWT')});
      runApp(MessRepApp(
        initialRoute: '/',
        loginRepository: loginRepository,
        issuesRepository: issuesRepository,
      ));
    } else {
      runApp(MessRepApp(
        initialRoute: '/login',
        loginRepository: loginRepository,
        issuesRepository: issuesRepository,
      ));
    }
  });
}

class MessRepApp extends StatelessWidget {
  const MessRepApp(
      {@required this.initialRoute,
      @required this.loginRepository,
      @required this.issuesRepository,
      Key key})
      : super(key: key);

  final String initialRoute;
  final LoginRepository loginRepository;
  final IssuesRepository issuesRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mess Rep App',
      theme: ThemeData(
        accentColor: Color(0xFF766B6B),
        appBarTheme: AppBarTheme(color: Colors.white, elevation: 0.0),
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) {
          return ChangeNotifierProvider.value(
            value: IssueNotifier(issuesRepository),
            child: IssueScreen(),
          );
        },
        '/login': (context) {
          return Provider.value(
            value: loginRepository,
            child: LoginScreen(),
          );
        },
      },
    );
  }
}
