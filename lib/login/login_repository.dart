import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messrep_app/util/network_client.dart';
import 'package:messrep_app/util/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  LoginRepository({
    @required SharedPreferences preferences,
    @required NetworkClient client,
  })  : this._prefs = preferences,
        this._client = client;

  final SharedPreferences _prefs;
  final NetworkClient _client;
  final _signIn = GoogleSignIn(
    scopes: ['email'],
    hostedDomain: 'pilani.bits-pilani.ac.in',
  );

  Future<String> signInWithGoogle() async {
    await _signIn.signOut();
    final account = await _signIn.signIn();
    return (await account.authentication).idToken;
  }

  Future<void> login(String idToken) async {
    final body = jsonEncode({
      'id_token': idToken,
    });

    final res = await _client.post('/login', body: body);

    if (res.statusCode != 200) {
      try {
        throw Exception(jsonDecode(res.body)['message']);
      } on Exception {
        throw Exception('${res.statusCode} error');
      }
    }

    final userJson = jsonDecode(res.body);

    await _prefs.setString(PrefKeys.jwt, userJson['JWT']);
    await _prefs.setString(PrefKeys.userId, userJson['id']);
    await _prefs.setString(PrefKeys.userName, userJson['name']);
    await _prefs.setString(PrefKeys.userRoom, userJson['room']);

    _client.headers.addAll({'Authorization': userJson['JWT']});
  }
}
