import 'package:flutter/material.dart';

class VsEmptyState extends StatelessWidget {
  const VsEmptyState({
    super.key,
    required this.lottieAsset,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String lottieAsset;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    // TODO: implement
    return const SizedBox.shrink();
  }
}
