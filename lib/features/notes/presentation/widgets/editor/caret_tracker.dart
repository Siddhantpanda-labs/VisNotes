import 'package:flutter/material.dart';

class CaretTracker extends StatefulWidget {
  const CaretTracker({super.key});

  @override
  State<CaretTracker> createState() => _CaretTrackerState();
}

class _CaretTrackerState extends State<CaretTracker> {
  @override
  void initState() {
    super.initState();
    _ensureVisible();
  }

  @override
  void didUpdateWidget(CaretTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureVisible();
  }

  void _ensureVisible() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          alignment: 0.8, // Keep it towards the bottom of the screen
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 1, height: 24);
  }
}
