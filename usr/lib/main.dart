import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aviator Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AviatorGameScreen(),
      },
    );
  }
}

class AviatorGameScreen extends StatefulWidget {
  const AviatorGameScreen({super.key});

  @override
  State<AviatorGameScreen> createState() => _AviatorGameScreenState();
}

class _AviatorGameScreenState extends State<AviatorGameScreen> {
  // Game State
  double _multiplier = 1.0;
  bool _isRunning = false;
  bool _isCrashed = false;
  String _resultMessage = "Place your bet and start the game!";
  
  // Betting
  final TextEditingController _betController = TextEditingController(text: "10.0");
  double _currentBet = 0.0;
  
  // Timer
  Timer? _gameTimer;
  final Random _random = Random();

  @override
  void dispose() {
    _gameTimer?.cancel();
    _betController.dispose();
    super.dispose();
  }

  void _startGame() {
    // Validate bet
    final double? bet = double.tryParse(_betController.text);
    if (bet == null || bet <= 0) {
      setState(() {
        _resultMessage = "Please enter a valid bet amount.";
      });
      return;
    }

    setState(() {
      _currentBet = bet;
      _multiplier = 1.0;
      _isRunning = true;
      _isCrashed = false;
      _resultMessage = "Game in progress...";
    });

    // Start the game loop
    _gameTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _gameLoop();
    });
  }

  void _gameLoop() {
    // Increase multiplier gradually (randomly between 1.01x and 1.10x per tick)
    // Using logic similar to the provided Python code
    double increase = 1.01 + _random.nextDouble() * (1.10 - 1.01);
    
    // Random chance of crash
    // Python logic: if crash_chance < min(self.multiplier / 200, 0.1)
    double crashChance = _random.nextDouble();
    double crashThreshold = min(_multiplier / 200, 0.1);

    if (crashChance < crashThreshold) {
      _handleCrash();
    } else {
      setState(() {
        _multiplier *= increase;
      });
    }
  }

  void _handleCrash() {
    _gameTimer?.cancel();
    setState(() {
      _isRunning = false;
      _isCrashed = true;
      _resultMessage = "CRASH! The plane went down. You lost your bet.";
    });
  }

  void _cashOut() {
    if (_isRunning) {
      _gameTimer?.cancel();
      double payout = _currentBet * _multiplier;
      setState(() {
        _isRunning = false;
        _resultMessage = "You cashed out! Payout: \$${payout.toStringAsFixed(2)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aviator Game'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Multiplier Display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isCrashed ? Colors.red.shade100 : Colors.green.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _isCrashed ? Colors.red : Colors.green,
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _isCrashed ? "CRASHED" : "${_multiplier.toStringAsFixed(2)}x",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _isCrashed ? Colors.red : Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Icon(Icons.flight_takeoff, size: 40),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Result Message
            Text(
              _resultMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            
            const SizedBox(height: 40),
            
            // Bet Input
            TextField(
              controller: _betController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              enabled: !_isRunning,
              decoration: const InputDecoration(
                labelText: "Bet Amount (\$)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Controls
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? null : _startGame,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("START GAME", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? _cashOut : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("CASH OUT", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
