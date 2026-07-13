import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VideoEdit Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  Future<void> _showInspiration(BuildContext context) async {
    const url = 'https://api.quotable.io/random';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quote = data['content'];
        final author = data['author'];
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Inspiration'),
              content: Text('"$quote"\n\n— $author'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _placeholderAction(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature: requires backend integration')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        title: const Text('VideoEdit Demo'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _placeholderAction(context, 'Pick Video'),
        icon: const Icon(FeatherIcons.video),
        label: const Text('Pick Video'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome! Choose a tool to get started.',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildFeatureCard(
                    context,
                    icon: FeatherIcons.mic,
                    label: 'Inspire Me',
                    onTap: () => _showInspiration(context),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: FeatherIcons.crop,
                    label: 'Trim Video',
                    onTap: () => _placeholderAction(context, 'Trim Video'),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: FeatherIcons.music,
                    label: 'Add Music',
                    onTap: () => _placeholderAction(context, 'Add Music'),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: FeatherIcons.filter,
                    label: 'Apply Filter',
                    onTap: () => _placeholderAction(context, 'Apply Filter'),
                  ),
                  _buildFeatureCard(
                    context,
                    icon: FeatherIcons.download, // replaced invalid FeatherIcons.save
                    label: 'Export',
                    onTap: () => _placeholderAction(context, 'Export'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
