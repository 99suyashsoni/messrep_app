import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messrep_app/issues/issue_notifier.dart';
import 'package:provider/provider.dart';

class IssueScreen extends StatelessWidget {
  const IssueScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _Issues(),
      ),
    );
  }
}

class _Issues extends StatefulWidget {
  @override
  State<_Issues> createState() => _IssuesState();
}

class _IssuesState extends State<_Issues> {

  String _reason;

  @override
  Widget build(BuildContext context) {
    return Consumer<IssueNotifier>(
      // ignore: missing_return
      builder: (_, issues, __) {
        final state = issues.state;

        if (state is Loading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is Failure) {
          return Center(child: Text(state.error));
        }
        if (state is Success) {
          return ListView.separated(
            padding: const EdgeInsets.all(12.0),
            itemCount: state.issues.length,
            separatorBuilder: (_, i) => SizedBox(height: 12.0),
            itemBuilder: (context, position) {
              return Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Text(state.issues[position].title)),
                          Icon(Icons.arrow_upward),
                          Text(state.issues[position].upVoteCount.toString()),
                        ],
                      ),
                      SizedBox(
                        height: 16.0
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: 3,
                              maxLength: 70,
                              onChanged: (reason) {
                                setState(() {
                                  _reason = reason;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 12.0
                          ),
                          RaisedButton(
                            child: Text('Close'),
                            onPressed: () async {
                              await issues.closeIssue(state.issues[position].id, _reason);
                              _reason = null;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
