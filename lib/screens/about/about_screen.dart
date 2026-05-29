import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<String> _teamMembers = [
    'Member A — GitHub: @member-a',
    'Member B — GitHub: @member-b',
    'Member C — GitHub: @member-c',
    'Member D — GitHub: @member-d',
  ];

  static const List<String> _packages = [
    'flutter_riverpod',
    'go_router',
    'shared_preferences',
    'cached_network_image',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _InfoCard(),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Team',
            children: [
              for (final member in _teamMembers)
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(member),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Main Packages',
            children: [
              for (final package in _packages)
                ListTile(
                  leading: const Icon(Icons.extension_outlined),
                  title: Text(package),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              "MoodMatch recommends movies, series, and music based on the user's current mood. Users can choose a mood and receive suitable entertainment suggestions.",
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ...children,
        ],
      ),
    );
  }
}
