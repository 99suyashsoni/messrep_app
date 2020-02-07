import 'package:flutter/material.dart';

class Issue{
  const Issue({
    @required this.id,
    @required this.title,
    @required this.upVoteCount
  });

  final int id;
  final String title;
  final int upVoteCount;
}