import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

Widget buildListTileShimmerEffect() {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: 4,
    itemBuilder: (_, __) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14,
                width: MediaQuery.of(Get.context!).size.width * 0.7,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 6),
              Container(
                height: 14,
                width: 160,
                color: Colors.grey[300],
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[300],
            size: 18,
          ),
        ),
      );
    },
  );
}
