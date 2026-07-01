import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VsLoading extends StatelessWidget {
  const VsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              color: Colors.black26,
              child: Center(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
