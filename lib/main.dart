import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NumberGuessingGame(),
    );
  }
}

class NumberGuessingGame extends StatefulWidget {
  @override
  _NumberGuessingGameState createState() => _NumberGuessingGameState();
}

class _NumberGuessingGameState extends State<NumberGuessingGame> {
  int _targetNumber = 0;
  int _userGuess = 0;
  int _attemptsLeft = 5;
  int _level = 1; // Niveau actuel
  int _correctGuesses =
      0; // Nombre de fois que l'utilisateur a trouvé le nombre
  String _message = "Devinez le nombre:";
  Timer? _timer;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _generateTargetNumber();
  }

  void _generateTargetNumber() {
    final random = Random();
    int maxNumber =
        10 + (_level - 1) * 5; // Augmenter l'intervalle en fonction du niveau
    _targetNumber = random.nextInt(maxNumber + 1);
    _userGuess = 0;
    _attemptsLeft = 5;
    _message = "Devinez le nombre:";
    _clearTextField();
  }

  void _clearTextField() {
    _textEditingController.clear();
  }

  final _textEditingController = TextEditingController();

  void _checkGuess() {
    if (_attemptsLeft <= 0) {
      setState(() {
        _message =
            "Vous avez épuisé vos essais. Le nombre à deviner était $_targetNumber.";
        _level = 1; // Revenir au niveau de départ en cas d'échec
        _correctGuesses = 0; // Réinitialiser le compteur de bonnes réponses
      });
      return;
    }

    if (_userGuess == _targetNumber) {
      setState(() {
        _message = "Bravo, vous avez trouvé le nombre $_targetNumber !";
        _correctGuesses++;
        if (_correctGuesses == 1) {
          // Passage au niveau suivant après une seule bonne réponse
          _level++; // Passer au niveau suivant
          _correctGuesses = 0; // Réinitialiser le compteur de bonnes réponses
        }

        if (_level > 5) {
          _gameOver = true; // Le joueur a terminé les 5 niveaux
        }
      });

      if (_gameOver) {
        // Si le jeu est terminé, arrêtez ici et ne générez pas un nouveau nombre
        return;
      }

      _generateTargetNumber(); // Générer un nouveau nombre après chaque essai réussi
    } else if (_userGuess < _targetNumber) {
      setState(() {
        _message = "Le nombre à deviner est plus grand";
        _attemptsLeft--;
      });
    } else {
      setState(() {
        _message = "Le nombre à deviner est plus petit";
        _attemptsLeft--;
      });
    }
  }

  void _incrementGuess() {
    setState(() {
      _userGuess = (_userGuess ?? 0) + 1;
      int maxNumber = 10 + (_level - 1) * 5;
      if (_userGuess > maxNumber) {
        _userGuess = maxNumber;
      }
      _textEditingController.text = '$_userGuess';
    });
  }

  void _decrementGuess() {
    setState(() {
      _userGuess = (_userGuess ?? 0) - 1;
      if (_userGuess < 0) {
        _userGuess = 0;
      }
      _textEditingController.text = '$_userGuess';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devinette de nombre'),
        actions: [
          Row(
            children: <Widget>[
              Icon(Icons.star,
                  color: _level >= 1 ? Colors.yellow : Colors.grey),
              Icon(Icons.star,
                  color: _level >= 2 ? Colors.yellow : Colors.grey),
              Icon(Icons.star,
                  color: _level >= 3 ? Colors.yellow : Colors.grey),
              Icon(Icons.star,
                  color: _level >= 4 ? Colors.yellow : Colors.grey),
              Icon(Icons.star,
                  color: _level >= 5 ? Colors.yellow : Colors.grey),
            ],
          ),
        ],
      ),
      body: Center(
        child: _gameOver
            ? _buildGameOverWidget()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _message,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Vous avez choisi : ${_userGuess ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Essais restants : $_attemptsLeft',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onLongPress: _decrementGuess,
                        onLongPressUp: () {},
                        child: ElevatedButton(
                          onPressed: _decrementGuess,
                          child: const Text('-'),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      GestureDetector(
                        onLongPress: _incrementGuess,
                        onLongPressUp: () {},
                        child: ElevatedButton(
                          onPressed: _incrementGuess,
                          child: const Text('+'),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _checkGuess,
                    child: Text('Valider'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _generateTargetNumber,
                    child: Text('Nouveau nombre'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGameOverWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Félicitations! Vous avez terminé les 5 niveaux!",
          style: const TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            // Réinitialiser le jeu et commencer à nouveau
            setState(() {
              _gameOver = false;
              _level = 1;
              _correctGuesses = 0;
            });
            _generateTargetNumber();
          },
          child: Text('Rejouer'),
        ),
      ],
    );
  }
}
