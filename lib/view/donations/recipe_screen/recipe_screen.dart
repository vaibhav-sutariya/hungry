import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/view_models/controllers/donation_view_model/recipe_view_model/recipe_view_model.dart';
import 'package:shimmer/shimmer.dart';

class RecipeScreen extends StatelessWidget {
  final RecipeViewModel viewModel;

  const RecipeScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Recipe'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                // Show typing effect or recipe content after generation
                if (viewModel.isLoading.value) {
                  return Column(
                    children: [
                      buildShimmerEffect(
                          height: 20), // Shimmer for chat/description
                      const SizedBox(height: 16),
                      buildShimmerEffect(
                          height: 100), // Shimmer for recipe content
                    ],
                  );
                } else if (viewModel.isRecipeGenerated.value) {
                  return _buildTypingEffect(viewModel.recipe.value);
                } else {
                  return Container();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // A function to return a shimmer effect for specific areas
  Widget buildShimmerEffect({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTypingEffect(String text) {
    return TypingEffectWidget(
      text: text,
      typingSpeed: 10,
    );
  }
}

class TypingEffectWidget extends StatefulWidget {
  final String text;
  final int typingSpeed;

  const TypingEffectWidget(
      {Key? key, required this.text, required this.typingSpeed})
      : super(key: key);

  @override
  _TypingEffectWidgetState createState() => _TypingEffectWidgetState();
}

class _TypingEffectWidgetState extends State<TypingEffectWidget> {
  late String _displayedText;
  late int _currentCharIndex;
  late Timer _typingTimer;

  @override
  void initState() {
    super.initState();
    _displayedText = '';
    _currentCharIndex = 0;
    _startTypingEffect();
  }

  @override
  void dispose() {
    _typingTimer.cancel();
    super.dispose();
  }

  void _startTypingEffect() {
    _typingTimer =
        Timer.periodic(Duration(milliseconds: widget.typingSpeed), (timer) {
      setState(() {
        if (_currentCharIndex < widget.text.length) {
          _displayedText += widget.text[_currentCharIndex];
          _currentCharIndex++;
        } else {
          _typingTimer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(
        _displayedText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
