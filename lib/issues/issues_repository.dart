import 'package:flutter/material.dart';
import 'package:messrep_app/util/network_client.dart';
import 'package:sqflite/sqflite.dart';

class IssuesRepository {
  IssuesRepository({
    @required Database database,
    @required NetworkClient client,
  }): this._db = database,
      this._client = client;

  final Database _db;
  final NetworkClient _client;
  List<String> _issues = [];
}