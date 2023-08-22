// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ript_revenge/models/models.dart';
import 'package:ript_revenge/services/services.dart';

class GameScreen extends StatelessWidget {
  final Game game;
  const GameScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('This is a game'),
              Text('Game id: ${game.uid}'),
              ElevatedButton(
                onPressed: () async {
                  await GameService.endGame(context, game: game);
                },
                child: Text('End Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
