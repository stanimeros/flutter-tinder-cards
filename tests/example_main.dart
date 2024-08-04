import 'package:flutter/material.dart';
import 'package:flutter_tinder_cards/tinder_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void customFunction(Key key, String direction) {
    debugPrint('$key went $direction');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: List.generate(20, (index) {
            return Padding(
              padding: const EdgeInsets.all(36),
              child: TinderCard(
                key: UniqueKey(),
                imageURLs: const [
                  'https://via.placeholder.com/500/0000FF/808080?text=Image+1',
                  'https://via.placeholder.com/500/FF0000/FFFFFF?text=Image+2',
                  'https://via.placeholder.com/500/00FF00/000000?text=Image+3',
                ],
                onDrag: customFunction,
              ),
            );
          }),
        ),
      ),
    );
  }
}
