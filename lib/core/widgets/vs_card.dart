import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class VsCard extends StatelessWidget {
  const VsCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    return Card(
      color: color ?? AppColors.vsSurface,
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              splashColor: AppColors.vsAccent.withOpacity(0.1),
              child: content,
            ),
    );
  }
}
