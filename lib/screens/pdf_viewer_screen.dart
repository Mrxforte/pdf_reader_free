import 'package:flutter/material.dart';
import '../widgets/zoom_controls.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ...show PDF file, zoom controls...
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: Column(
        children: [
          Expanded(child: Center(child: Text('PDF Viewer Area'))),
          ZoomControls(),
        ],
      ),
    );
  }
}
