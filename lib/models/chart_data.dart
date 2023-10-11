// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class ChartData {
  Color barColor;
  String x;
  int y;
  String name;

  ChartData({
    required this.barColor,
    required this.x,
    required this.y,
    required this.name,
  });

  ChartData copyWith({
    Color? barColor,
    String? x,
    int? y,
    String? name,
  }) {
    return ChartData(
      barColor: barColor ?? this.barColor,
      x: x ?? this.x,
      y: y ?? this.y,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'barColor': barColor.value,
      'x': x,
      'y': y,
      'name': name,
    };
  }

  factory ChartData.fromMap(Map<String, dynamic> map) {
    return ChartData(
      barColor: Color(map['barColor'] as int),
      x: map['x'] as String,
      y: map['y'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChartData.fromJson(String source) =>
      ChartData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChartData(barColor: $barColor, x: $x, y: $y, name: $name)';
  }

  @override
  bool operator ==(covariant ChartData other) {
    if (identical(this, other)) return true;

    return other.barColor == barColor &&
        other.x == x &&
        other.y == y &&
        other.name == name;
  }

  @override
  int get hashCode {
    return barColor.hashCode ^ x.hashCode ^ y.hashCode ^ name.hashCode;
  }
}
