import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Getting Started',
            children: const [
              _HelpItem(
                title: 'Add a PDF',
                body: 'Tap the + button to import a PDF from your device.',
              ),
              _HelpItem(
                title: 'Favorites',
                body: 'Swipe a file and tap Favorite to pin it.',
              ),
              _HelpItem(
                title: 'Recents',
                body: 'Files you open appear automatically in Recent.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Troubleshooting',
            children: const [
              _HelpItem(
                title: 'Can’t open a file',
                body: 'Check storage permissions and file availability.',
              ),
              _HelpItem(
                title: 'Cloud sync',
                body: 'Ensure Firebase services are enabled and online.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Contact Support'),
              subtitle: const Text('support@example.com'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: const Text('Report an issue'),
              subtitle: const Text('Open a GitHub issue'),
              onTap: () {},
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: theme.colorScheme.surface,
        child: Text(
          'We typically respond within 24–48 hours.',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String title;
  final String body;

  const _HelpItem({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle_outline),
      title: Text(title),
      subtitle: Text(body),
    );
  }
}
