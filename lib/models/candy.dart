import 'package:flutter/material.dart';

enum CandyType {
  red,
  blue,
  green,
  yellow,
  purple,
  orange,
}

class Candy {
  final CandyType type;
  final int row;
  final int col;
  bool isMatched;
  bool isAnimating;

  Candy({
    required this.type,
    required this.row,
    required this.col,
    this.isMatched = false,
    this.isAnimating = false,
  });

  Candy copyWith({
    CandyType? type,
    int? row,
    int? col,
    bool? isMatched,
    bool? isAnimating,
  }) {
    return Candy(
      type: type ?? this.type,
      row: row ?? this.row,
      col: col ?? this.col,
      isMatched: isMatched ?? this.isMatched,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }

  IconData get icon {
    switch (type) {
      case CandyType.red:
        return Icons.favorite;
      case CandyType.blue:
        return Icons.water_drop;
      case CandyType.green:
        return Icons.eco;
      case CandyType.yellow:
        return Icons.star;
      case CandyType.purple:
        return Icons.diamond;
      case CandyType.orange:
        return Icons.local_fire_department;
    }
  }

  Color get color {
    switch (type) {
      case CandyType.red:
        return Colors.red;
      case CandyType.blue:
        return Colors.blue;
      case CandyType.green:
        return Colors.green;
      case CandyType.yellow:
        return Colors.yellow;
      case CandyType.purple:
        return Colors.purple;
      case CandyType.orange:
        return Colors.orange;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Candy &&
        other.type == type &&
        other.row == row &&
        other.col == col;
  }

  @override
  int get hashCode => Object.hash(type, row, col);
} 