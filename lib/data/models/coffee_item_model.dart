import 'package:flutter/material.dart';

/// Coffee Item Model for Select Coffee View
class CoffeeItem {
  final String id;
  final String name;
  final String description;
  final Color color;
  final String? imageUrl;

  const CoffeeItem({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    this.imageUrl,
  });
}
