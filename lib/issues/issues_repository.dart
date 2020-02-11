import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messrep_app/issues/issue.dart';
import 'package:messrep_app/util/network_client.dart';
import 'package:sqflite/sqflite.dart';

class IssuesRepository {
  IssuesRepository({
    @required Database database,
    @required NetworkClient client,
  })  : this._db = database,
        this._client = client;

  final Database _db;
  final NetworkClient _client;
  List<Issue> _issues = [];

  Future<List<Issue>> get issues async {
    await refresh();
    await _populateCache();
    return _issues;
  }

  Future<void> refresh() async {
    final response = await _client.get('/issues');

    if (response.statusCode != 200) {
      try {
        throw Exception(jsonDecode(response.body)['message']);
      } on Exception {
        throw Exception('${response.statusCode} error');
      }
    }

    final issuesJson = jsonDecode(response.body);
    final activeIssuesJson = issuesJson['active'];

    await _db.transaction((txn) async {
      await txn.rawDelete('''
        DELETE 
        FROM Issues
      ''');

      for (var issueJson in activeIssuesJson) {
        await txn.rawInsert('''
          INSERT 
          INTO Issues (id, title, upvoteCount)
          VALUES (?, ?, ?)
        ''', [
          issueJson['id'],
          issueJson['title'],
          issueJson['upvote_count'],
        ]);
      }
    });

    await _populateCache();
  }

  Future<void> _populateCache() async {
    _issues.clear();

    final rows = await _db.rawQuery('''
      SELECT id, title, upvoteCount 
      FROM Issues 
      ORDER BY upvoteCount DESC
    ''');

    for (var row in rows) {
      _issues.add(Issue(
        id: row['id'],
        title: row['title'],
        upVoteCount: row['upvoteCount'],
      ));
    }
  }

  Future<void> resolveIssue(int issueId, String reason) async {
    final body = {'issue_id': issueId, 'reason': reason};

    final response = await _client.post('/issues/close', body: jsonEncode(body));

    if(response.statusCode != 200){
      try {
        throw Exception(jsonDecode(response.body)['message']);
      } on Exception {
        throw Exception('${response.statusCode} error');
      }
    }
  }
}
