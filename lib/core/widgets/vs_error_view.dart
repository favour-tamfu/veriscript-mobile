import 'package:flutter/material.dart';

import 'vs_button.dart';

class VsErrorView extends StatelessWidget {
  const VsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          VsButton.primary(
            label: 'Try again',
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
