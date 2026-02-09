import 'package:flutter/material.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ...list recent PDF files...
    return Scaffold(
      appBar: AppBar(title: Text('Recent')),
      body: Center(child: Text('Recent Screen')),
    );
  }
}
