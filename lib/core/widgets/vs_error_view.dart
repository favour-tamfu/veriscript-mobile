import 'package:flutter/material.dart';

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
    // TODO: implement
    return const SizedBox.shrink();
  }
}
