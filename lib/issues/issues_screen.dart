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
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Consumer<IssueNotifier>(
            // ignore: missing_return
            builder: (_, issues,__) {
              final state = issues.state;

              if(state is Loading){
                return Center(child: CircularProgressIndicator());
              }
              if(state is Failure){
                return Center(child: Text(state.error));
              }
              if(state is Success){
                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: state.issues.length,
                  itemBuilder: (context, position) {
                    return Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(state.issues[position].title),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    issues.closeIssue(state.issues[position].id, 'Solved');
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
          )),
    );
  }
}
