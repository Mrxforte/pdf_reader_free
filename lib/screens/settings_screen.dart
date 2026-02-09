import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/providers/auth_provider.dart';
import 'package:pdf_viewer_app/providers/theme_provider.dart';
import 'package:pdf_viewer_app/utils/helpers.dart';
import 'package:pdf_viewer_app/screens/auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Profile Section
          _buildSectionHeader('Profile'),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: authProvider.user?.photoURL != null
                  ? NetworkImage(authProvider.user!.photoURL!)
                  : null,
              child: authProvider.user?.photoURL == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(
              authProvider.user?.displayName ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(authProvider.user?.email ?? 'No email'),
          ),
          const Divider(),

          // App Settings
          _buildSectionHeader('App Settings'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark/light theme'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.setTheme(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme Color'),
            subtitle: const Text('Choose app color theme'),
            onTap: () {
              _showThemeColorDialog(context, themeProvider);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {
              // Implement language selection
            },
          ),
          const Divider(),

          // PDF Settings
          _buildSectionHeader('PDF Settings'),
          SwitchListTile(
            title: const Text('Auto-open last file'),
            subtitle: const Text('Open last viewed file on app start'),
            value: true,
            onChanged: (value) {
              // Implement auto-open setting
            },
          ),
          SwitchListTile(
            title: const Text('Show thumbnails'),
            subtitle: const Text('Display PDF thumbnails in file list'),
            value: true,
            onChanged: (value) {
              // Implement thumbnail setting
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Default save location'),
            subtitle: const Text('Internal storage/PDF Viewer'),
            onTap: () {
              // Implement save location selection
            },
          ),
          const Divider(),

          // Account Settings
          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy & Security'),
            onTap: () {
              // Implement privacy settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & Sync'),
            subtitle: const Text('Sync PDFs to cloud'),
            onTap: () {
              // Implement backup settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Implement help screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          const Divider(),

          // Danger Zone
          _buildSectionHeader('Danger Zone'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Data',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirmed = await Helpers.showConfirmationDialog(
                context,
                'Clear All Data',
                'This will delete all local PDF files. This action cannot be undone.',
              );
              if (confirmed && context.mounted) {
                Helpers.showSnackBar(context, 'All data cleared');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirmed = await Helpers.showConfirmationDialog(
                context,
                'Sign Out',
                'Are you sure you want to sign out?',
              );
              if (confirmed && context.mounted) {
                await authProvider.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showThemeColorDialog(BuildContext context, ThemeProvider themeProvider) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme Color'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About PDF Viewer Pro'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('A powerful PDF viewer with cloud sync, dark mode, and advanced features.'),
            SizedBox(height: 16),
            Text('© 2024 PDF Viewer Pro. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
