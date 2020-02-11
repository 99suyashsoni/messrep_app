import 'package:flutter/material.dart';
import 'package:messrep_app/issues/issue.dart';
import 'package:messrep_app/issues/issues_repository.dart';


abstract class UiState{
  const UiState();
}

class Loading extends UiState{
  const Loading();
}

class Success extends UiState{
  const Success(this.issues);
  final List<Issue> issues;
}

class Failure extends UiState{
  const Failure(this.error);
  final String error;
}

class IssueNotifier extends ChangeNotifier{
  IssueNotifier(IssuesRepository issuesRepository): this._repo = issuesRepository {
    getIssues();
  }

  final IssuesRepository _repo;
  UiState _state = Loading();

  UiState get state => _state;

  void getIssues() {
    _repo.issues.then((issues) {
      _state = Success(issues);
      notifyListeners();
    }).catchError((error) {
      _state = Failure(error.toString());
      notifyListeners();
    });
  }

  Future<void> closeIssue(int issueId, String reason) async {
    _state = Loading();
    notifyListeners();
    await _repo.resolveIssue(issueId, reason);
    getIssues();
  }
}