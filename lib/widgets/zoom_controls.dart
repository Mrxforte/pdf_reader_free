import 'package:flutter/material.dart';

class ZoomControls extends StatelessWidget {
  const ZoomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.zoom_in),
          onPressed: () {
            /* zoom in */
          },
        ),
        IconButton(
          icon: Icon(Icons.zoom_out),
          onPressed: () {
            /* zoom out */
          },
        ),
      ],
    );
  }
}
