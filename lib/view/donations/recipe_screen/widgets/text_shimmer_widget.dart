import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe title
            Container(
              height: 28,
              width: MediaQuery.of(Get.context!).size.width * 0.7,
              color: Colors.white,
            ),
            const SizedBox(height: 24),

            // Recipe introduction paragraph
            Container(
              height: 16,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            Container(
              height: 16,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            Container(
              height: 16,
              width: MediaQuery.of(Get.context!).size.width * 0.7,
              color: Colors.white,
            ),

            const SizedBox(height: 24),

            // Ingredients section title
            Container(
              height: 22,
              width: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 12),

            // Ingredients list
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 16,
                  width: MediaQuery.of(Get.context!).size.width * 0.5,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions section title
            Container(
              height: 22,
              width: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 12),

            // Instructions
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step number
                    Container(
                      height: 18,
                      width: 60,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                    ),
                    // Step description
                    Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
