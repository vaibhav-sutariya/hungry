import 'package:flutter/material.dart';

class ActionTileModel {
  final String title;
  final IconData icon;
  final Color color;
  final Function() onTap;

  ActionTileModel({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
