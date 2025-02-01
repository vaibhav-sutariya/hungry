import 'package:flutter/material.dart';
import 'package:hungry/res/components/app_bar/widgets/drawer_tile.dart';

class DrawerExpansionTile extends StatelessWidget {
  final String title;
  final List<DrawerTile> children;

  const DrawerExpansionTile({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
      ),
      children: children,
    );
  }
}
