import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  final int id;

  const CommentsPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("Item ID: $id"),
      ),
    );
  }
}
