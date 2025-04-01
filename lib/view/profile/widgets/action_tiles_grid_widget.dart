import 'package:flutter/material.dart';

class ActionTilesGridWidget extends StatelessWidget {
  final List<dynamic> actionTiles;

  const ActionTilesGridWidget({
    super.key,
    required this.actionTiles,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.045; // Adjust text size based on width
    double iconSize = screenWidth * 0.12; // Adjust icon size dynamically
    int crossAxisCount = (screenWidth ~/ 150).clamp(2, 4); // Responsive columns

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Actions",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: actionTiles.length,
              itemBuilder: (context, index) {
                final tile = actionTiles[index];
                return _buildActionTile(tile, fontSize, iconSize);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionTile(tile, double fontSize, double iconSize) {
    return InkWell(
      onTap: tile.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              tile.color,
              tile.color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: tile.color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tile.icon,
                size: iconSize,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                tile.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize * 0.7,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
