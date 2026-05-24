import 'package:flutter/material.dart';

class VsButton extends StatelessWidget {
  const VsButton._({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    required this.variant,
  });

  factory VsButton.primary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) {
    return VsButton._(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      variant: _VsButtonVariant.primary,
    );
  }

  factory VsButton.secondary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return VsButton._(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      variant: _VsButtonVariant.secondary,
    );
  }

  factory VsButton.text({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return VsButton._(
      key: key,
      label: label,
      onPressed: onPressed,
      variant: _VsButtonVariant.text,
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final _VsButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    // TODO: implement
    return const SizedBox.shrink();
  }
}

enum _VsButtonVariant { primary, secondary, text }
