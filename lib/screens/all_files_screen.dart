import 'package:flutter/material.dart';

class AllFilesScreen extends StatelessWidget {
  const AllFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ...list all PDF files...
    return Scaffold(
      appBar: AppBar(title: Text('All Files')),
      body: Center(child: Text('All Files Screen')),
    );
  }
}
