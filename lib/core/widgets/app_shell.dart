import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, this.header, this.footer});

  final Widget child;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE4EEF7), AppColors.cloud, Color(0xFFF9FBFD)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null) header!,
                Expanded(child: child),
                if (footer != null) ...[const SizedBox(height: 16), footer!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
