import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:ewelink/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.devices,
              size: 65,
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: 8),
            Text(
              'eWelink Device Manager',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Version 3.0',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentColor,
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GlossyContainer(
              width: double.infinity,
              height: 100,
              opacity: 0.1,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A modern interface for managing your eWelink smart devices',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'This application allows you to view and control devices connected to your eWelink account. '
                      'It provides a sleek, modern interface with glassmorphic UI elements for a premium experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, height: 1.2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureSection(context),
            const SizedBox(height: 16),
            _buildCreditsSection(context),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection(BuildContext context) {
    return Column(
      children: [
        Text(
          'Features',
          style:
              Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        _buildFeatureItem(
          context,
          Icons.devices_other,
          'Device Management',
          'View and control all your eWelink devices in one place',
        ),
        _buildFeatureItem(
          context,
          Icons.search,
          'Search Functionality',
          'Quickly find devices by name, brand, or ID',
        ),
        _buildFeatureItem(
          context,
          Icons.toggle_on,
          'Toggle Controls',
          'Turn devices on and off with a simple tap',
        ),
        _buildFeatureItem(
          context,
          Icons.info_outline,
          'Detailed Information',
          'View comprehensive details about each device',
        ),
        _buildFeatureItem(
          context,
          Icons.save_alt,
          'Export Capability',
          'Export device data to JSON format',
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlossyContainer(
        width: double.infinity,
        height: 80,
        opacity: 0.1,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.accentColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreditsSection(BuildContext context) {
    return Column(
      children: [
        Text(
          'Credits',
          style:
              Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          'Built with Flutter and the Glossy package for glassmorphic UI effects.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        const Text(
          '© 2023 eWelink Manager',
          style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 11),
        ),
      ],
    );
  }
}
