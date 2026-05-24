import 'package:flutter/material.dart';

class VsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VsAppBar({
    super.key,
    this.title = 'VeriScript',
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // TODO: implement
    return const SizedBox.shrink();
  }
}
