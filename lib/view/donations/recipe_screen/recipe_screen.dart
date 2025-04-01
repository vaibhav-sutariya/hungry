import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/res/components/app_bar/app_bar.dart';
import 'package:hungry/res/components/app_bar/drawer.dart';
import 'package:hungry/view/donations/recipe_screen/widgets/text_shimmer_widget.dart';
import 'package:hungry/view_models/controllers/donation_view_model/recipe_view_model/recipe_view_model.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecipeViewModel viewModel = Get.put(RecipeViewModel());
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(showLogOut: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (viewModel.isLoading.value) {
                  return buildShimmerEffect();
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

  Widget _buildTypingEffect(String text) {
    log('Text to display: $text');
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
  late List<TextSpan> _textSpans;
  late int _currentCharIndex;
  late int _totalCharacters;
  late Timer _typingTimer;
  late String _rawText;

  @override
  void initState() {
    super.initState();
    _rawText = widget.text;
    _textSpans = [];
    _currentCharIndex = 0;
    _processRawText();
    _startTypingEffect();
  }

  void _processRawText() {
    // Calculate total character count after processing
    String processedText = _preProcessText(_rawText);
    _totalCharacters = processedText.length;
  }

  String _preProcessText(String text) {
    // Pre-process text to calculate the accurate length
    // Remove standalone numbers
    text = text.replaceAll(RegExp(r'^\d+$ ', multiLine: true), '');

    // Replace ** with empty string (for bold text)
    text = text.replaceAll("**", "");
    text = text.replaceAll("##", "");

    return text;
  }

  @override
  void dispose() {
    _typingTimer.cancel();
    super.dispose();
  }

  void _startTypingEffect() {
    // Process the text to identify bold sections and bullet points
    List<Map<String, dynamic>> processedSegments = _processText(_rawText);

    _typingTimer =
        Timer.periodic(Duration(milliseconds: widget.typingSpeed), (timer) {
      setState(() {
        if (_currentCharIndex < _totalCharacters) {
          // Update text spans based on current index
          _updateTextSpans(processedSegments, _currentCharIndex);
          _currentCharIndex++;
        } else {
          _typingTimer.cancel();
        }
      });
    });
  }

  List<Map<String, dynamic>> _processText(String text) {
    List<Map<String, dynamic>> segments = [];

    // Split text by lines to handle bullet points
    List<String> lines = text.split('\n');
    int currentPosition = 0;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      // Check if line starts with bullet point (* )
      if (line.trim().startsWith('* ')) {
        // Handle bullet point line - first add anything before this line
        if (i > 0) {
          segments.add({
            'text': '\n',
            'isBold': false,
            'isBullet': false,
            'startIndex': currentPosition
          });
          currentPosition += 1;
        }

        // Extract bullet point content (remove the * symbol)
        String bulletContent = line.trim().substring(2);

        // Check if bullet point content has bold sections
        List<Map<String, dynamic>> bulletSegments =
            _processBoldText(bulletContent);

        // Add bullet symbol at the beginning
        segments.add({
          'text': ' • ',
          'isBold': false,
          'isBullet': true,
          'startIndex': currentPosition
        });
        currentPosition += 2; // '• ' is 2 characters

        // Add formatted bullet content
        for (var segment in bulletSegments) {
          segments.add({
            'text': segment['text'],
            'isBold': segment['isBold'],
            'isBullet': false,
            'startIndex': currentPosition
          });
          currentPosition += (segment['text'].length as int);
        }
      } else {
        // Handle regular line with potential bold sections
        if (i > 0) {
          segments.add({
            'text': '\n',
            'isBold': false,
            'isBullet': false,
            'startIndex': currentPosition
          });
          currentPosition += 1;
        }

        // Process line for bold text
        List<Map<String, dynamic>> lineSegments = _processBoldText(line);

        for (var segment in lineSegments) {
          segments.add({
            'text': segment['text'],
            'isBold': segment['isBold'],
            'isBullet': false,
            'startIndex': currentPosition
          });
          currentPosition += (segment['text'].length as int);
        }
      }
    }

    return segments;
  }

  List<Map<String, dynamic>> _processBoldText(String text) {
    List<Map<String, dynamic>> segments = [];

    // Find all text between ** markers
    RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    // Find all matches of bold text
    for (Match match in boldPattern.allMatches(text)) {
      // Add normal text before this bold segment
      if (match.start > lastEnd) {
        String normalText = text.substring(lastEnd, match.start);
        normalText = _removeSpecialChars(normalText);
        if (normalText.isNotEmpty) {
          segments.add({'text': normalText, 'isBold': false});
        }
      }

      // Add bold text (without the ** markers)
      String boldText = match.group(1) ?? '';
      boldText = _removeSpecialChars(boldText);
      if (boldText.isNotEmpty) {
        segments.add({'text': boldText, 'isBold': true});
      }

      lastEnd = match.end;
    }

    // Add any remaining normal text
    if (lastEnd < text.length) {
      String remainingText = text.substring(lastEnd);
      remainingText = _removeSpecialChars(remainingText);
      if (remainingText.isNotEmpty) {
        segments.add({'text': remainingText, 'isBold': false});
      }
    }

    return segments;
  }

  String _removeSpecialChars(String text) {
    // Remove standalone numbers on their own line
    text = text.replaceAll(RegExp(r'^\d+$', multiLine: true), '');
    return text;
  }

  void _updateTextSpans(List<Map<String, dynamic>> segments, int currentIndex) {
    _textSpans = [];
    int processedChars = 0;

    for (var segment in segments) {
      String text = segment['text'];
      bool isBold = segment['isBold'];
      bool isBullet = segment['isBullet'] ?? false;

      // Calculate how much of this segment to show
      int charsToShow = currentIndex - processedChars;
      if (charsToShow <= 0) {
        break; // Haven't reached this segment yet
      }

      if (charsToShow >= text.length) {
        // Show the entire segment
        _textSpans.add(
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBullet ? Colors.black : Colors.black,
            ),
          ),
        );
        processedChars += text.length;
      } else {
        // Show partial segment
        _textSpans.add(
          TextSpan(
            text: text.substring(0, charsToShow),
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBullet ? Colors.black : Colors.black,
            ),
          ),
        );
        processedChars += charsToShow;
        break; // Don't process more segments
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RichText(
        text: TextSpan(
          children: _textSpans,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
