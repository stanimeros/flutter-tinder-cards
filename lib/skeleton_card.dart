import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkeletonCard extends StatelessWidget {
  final Color backgroundColor;

  const SkeletonCard({
    super.key,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Container(
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(15, 255, 255, 255),
                  spreadRadius: 12,
                  blurRadius: 24,
                )
              ]
            ),
          )
          .animate(
            onComplete: (controller) {
              controller.repeat();
            },
          ).slideX(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 2500),
            curve: Curves.linear,
            begin: -1.5,
            end: 1.5,
          ),
        ),
      ],
    );
  }
}