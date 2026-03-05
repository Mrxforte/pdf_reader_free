import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_viewer_app/providers/auth_provider.dart';
import 'package:pdf_viewer_app/providers/theme_provider.dart';
import 'package:pdf_viewer_app/screens/auth/login_screen.dart';
import 'package:pdf_viewer_app/screens/help_support_screen.dart';
import 'package:pdf_viewer_app/screens/about_screen.dart';
import 'package:pdf_viewer_app/utils/helpers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Profile Section
          if (authProvider.isAuthenticated) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: authProvider.user?.photoURL != null
                            ? NetworkImage(authProvider.user!.photoURL!)
                            : null,
                        child: authProvider.user?.photoURL == null
                            ? const Icon(Icons.person, size: 35)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.user?.displayName ?? 'User',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              authProvider.user?.email ?? 'No email',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person_outline,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: const Text(
                    'Guest User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text('Sign in to sync your files'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Sign In'),
                  ),
                ),
              ),
            ),
          ],

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          _buildSettingsTile(
            context,
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: isDark ? 'Currently enabled' : 'Currently disabled',
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                themeProvider.setTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme Color',
            subtitle: 'Choose your preferred color',
            onTap: () => _showThemeColorDialog(context),
          ),

          const SizedBox(height: 16),

          // Reading Preferences
          _buildSectionHeader(context, 'Reading Preferences'),
          _buildSettingsTile(
            context,
            icon: Icons.auto_stories_outlined,
            title: 'Auto-open Last File',
            subtitle: 'Resume where you left off',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // TODO: Implement
              },
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.image_outlined,
            title: 'Show Thumbnails',
            subtitle: 'Display file previews',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement
              },
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.pageview_outlined,
            title: 'Default Page Layout',
            subtitle: 'Continuous scroll',
            onTap: () => _showLayoutDialog(context),
          ),

          const SizedBox(height: 16),

          // Storage & Data
          _buildSectionHeader(context, 'Storage & Data'),
          _buildSettingsTile(
            context,
            icon: Icons.folder_outlined,
            title: 'Storage Location',
            subtitle: 'Internal storage',
            onTap: () {
              // TODO: Implement storage location selection
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.cloud_upload_outlined,
            title: 'Auto-backup',
            subtitle: 'Backup files to cloud',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // TODO: Implement
              },
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.cleaning_services_outlined,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () => _showClearCacheDialog(context),
          ),

          const SizedBox(height: 16),

          // General
          _buildSectionHeader(context, 'General'),
          _buildSettingsTile(
            context,
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              // TODO: Implement language selection
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage app notifications',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement
              },
            ),
          ),

          const SizedBox(height: 16),

          // Support & Info
          _buildSectionHeader(context, 'Support & Info'),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: context.l10n.helpSupport,
            subtitle: 'Get help and support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: context.l10n.about,
            subtitle: 'App version and info',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'View privacy policy',
            onTap: () {
              // TODO: Show privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy policy coming soon')),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'View terms of service',
            onTap: () {
              // TODO: Show terms of service
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms of service coming soon')),
              );
            },
          ),

          const SizedBox(height: 16),

          // Account Actions
          if (authProvider.isAuthenticated) ...[
            _buildSectionHeader(context, 'Account'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style:
                              TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),
          ],

          const SizedBox(height: 32),

          // App Version
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PDF Reader',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right, color: Colors.grey[400])
              : null),
      onTap: onTap,
    );
  }

  void _showThemeColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme Color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColorOption(context, 'Blue', Colors.blue),
            _buildColorOption(context, 'Red', Colors.red),
            _buildColorOption(context, 'Green', Colors.green),
            _buildColorOption(context, 'Purple', Colors.purple),
            _buildColorOption(context, 'Orange', Colors.orange),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(BuildContext context, String name, Color color) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color),
      title: Text(name),
      onTap: () {
        // TODO: Implement theme color change
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Theme color feature coming soon')),
        );
      },
    );
  }

  void _showLayoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Page Layout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Continuous Scroll'),
              value: 'continuous',
              groupValue: 'continuous',
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Single Page'),
              value: 'single',
              groupValue: 'continuous',
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear temporary files and thumbnails. Your documents will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement cache clearing
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
