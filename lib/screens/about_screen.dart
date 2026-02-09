import 'package:flutter/material.dart';
import 'package:pdf_viewer_app/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(AppConstants.appName),
              subtitle: Text('Version ${AppConstants.appVersion}'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'A fast and clean PDF viewer with favorites, recents, and cloud sync.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.security_outlined),
                  title: Text('Privacy'),
                  subtitle: Text('We don’t collect personal data.'),
                ),
                Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.verified_outlined),
                  title: Text('Licenses'),
                  subtitle: Text('Open-source components are used.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Project Repository'),
              subtitle: const Text('github.com/yourusername/pdf_viewer_free'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
