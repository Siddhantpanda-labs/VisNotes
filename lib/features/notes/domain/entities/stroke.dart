import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Stroke extends Equatable {
  final List<Offset> points;
  final List<double> pressures;
  final Color color;
  final double width;

  const Stroke({
    required this.points,
    required this.pressures,
    this.color = Colors.black,
    this.width = 2.0,
  });

  Stroke copyWith({
    List<Offset>? points,
    List<double>? pressures,
    Color? color,
    double? width,
  }) {
    return Stroke(
      points: points ?? this.points,
      pressures: pressures ?? this.pressures,
      color: color ?? this.color,
      width: width ?? this.width,
    );
  }

  @override
  List<Object?> get props => [points, pressures, color, width];
}
