import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/providers/auth_provider.dart';
import 'package:pdf_viewer_app/providers/theme_provider.dart';
import 'package:pdf_viewer_app/utils/helpers.dart';
import 'package:pdf_viewer_app/screens/auth/login_screen.dart';
import 'package:pdf_viewer_app/screens/help_support_screen.dart';
import 'package:pdf_viewer_app/screens/about_screen.dart';
import 'package:pdf_viewer_app/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: ListView(
        children: [
          // Profile Section
          _buildSectionHeader(context.l10n.profile),
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
          _buildSectionHeader(context.l10n.appSettings),
          SwitchListTile(
            title: Text(context.l10n.darkMode),
            subtitle: Text(context.l10n.toggleTheme),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.setTheme(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(context.l10n.appSettings),
            subtitle: Text(context.l10n.toggleTheme),
            onTap: () {
              _showThemeColorDialog(context, themeProvider);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(context.l10n.language),
            subtitle: const Text('English'),
            onTap: () {
              // Implement language selection
            },
          ),
          const Divider(),

          // PDF Settings
          _buildSectionHeader(context.l10n.pdfSettings),
          SwitchListTile(
            title: Text(context.l10n.autoOpenLastFile),
            subtitle: Text(context.l10n.openLastViewedFile),
            value: true,
            onChanged: (value) {
              // Implement auto-open setting
            },
          ),
          SwitchListTile(
            title: Text(context.l10n.showThumbnails),
            subtitle: Text(context.l10n.displayThumbnails),
            value: true,
            onChanged: (value) {
              // Implement thumbnail setting
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: Text(context.l10n.defaultSaveLocation),
            subtitle: Text(context.l10n.internalStorage),
            onTap: () {
              // Implement save location selection
            },
          ),
          const Divider(),

          // Account Settings
          _buildSectionHeader(context.l10n.account),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text(context.l10n.privacySecurity),
            onTap: () {
              // Implement privacy settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(context.l10n.backupSync),
            subtitle: Text(context.l10n.syncPDFs),
            onTap: () {
              // Implement backup settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(context.l10n.helpSupport),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(context.l10n.about),
            subtitle: Text(context.l10n.versionLabel('1.0.0')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          const Divider(),

          // Danger Zone
          _buildSectionHeader(context.l10n.dangerZone),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: Text(context.l10n.clearAllData,
                style: const TextStyle(color: Colors.red)),
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
            title: Text(context.l10n.signOut, style: const TextStyle(color: Colors.red)),
            onTap: () async {
              final confirmed = await Helpers.showConfirmationDialog(
                context,
                'Sign Out',
                'Are you sure you want to sign out?',
              );
              if (confirmed && context.mounted) {
                await authProvider.logout();
                if (!context.mounted) return;
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
}
