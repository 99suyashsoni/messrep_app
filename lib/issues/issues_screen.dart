import 'package:flutter/material.dart';
import 'package:messrep_app/issues/issue_notifier.dart';
import 'package:provider/provider.dart';

class IssueScreen extends StatelessWidget {
  const IssueScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8DECC),
            Color(0xFFE1DAD4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _Issues(),
        ),
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
          return RefreshIndicator(
            child: Center(child: Text(state.error)),
            onRefresh: () async {
              await issues.refresh();
            },
          );
        }
        if (state is Success) {
          return RefreshIndicator(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: state.issues.length,
                    separatorBuilder: (_, i) => SizedBox(height: 12.0),
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(state.issues[position].title)),
                                Icon(Icons.arrow_upward),
                                Text(state.issues[position].upVoteCount
                                    .toString()),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Reason:'),
                                        SizedBox(width: 20.0),
                                        Expanded(
                                          child: TextField(
                                              maxLines: 3,
                                              maxLength: 70,
                                              onChanged: (reason) {
                                                setState(() {
                                                  _reason = reason;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                    RaisedButton(
                                      child: Text('Close issue'),
                                      textColor: Color(0xFF6B6154),
                                      color: Color(0xFFFFE0A4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      onPressed: () async {
                                        if (_reason != null) {
                                          await issues.closeIssue(
                                              state.issues[position].id,
                                              _reason);
                                          _reason = null;
                                        } else {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Please enter reason'),
                                          ));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.0),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    child: Text('Logout'),
                    textColor: Color(0xFF6B6154),
                    color: Color(0xFFFFE0A4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    onPressed: () async {
                      await issues.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        ModalRoute.withName('/'),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
            onRefresh: () async {
              try {
                await issues.refresh();
              } on Exception catch (e) {
                print(e.toString());
              }
            },
          );
        }
      },
    );
  }
}
