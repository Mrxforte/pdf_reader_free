import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('PDF Viewer Free')),
          ListTile(
            title: Text('Home'),
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          ListTile(
            title: Text('All Files'),
            onTap: () => Navigator.pushNamed(context, '/all_files'),
          ),
          ListTile(
            title: Text('Favorites'),
            onTap: () => Navigator.pushNamed(context, '/favorites'),
          ),
          ListTile(
            title: Text('Recent'),
            onTap: () => Navigator.pushNamed(context, '/recent'),
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}
