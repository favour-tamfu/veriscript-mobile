import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

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
    switch (variant) {
      case _VsButtonVariant.primary:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.vsDark,
                    ),
                  )
                : _buttonChild(),
          ),
        );
      case _VsButtonVariant.secondary:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(label),
          ),
        );
      case _VsButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.vsAccent),
          ),
        );
    }
  }

  Widget _buttonChild() {
    if (icon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

enum _VsButtonVariant { primary, secondary, text }
