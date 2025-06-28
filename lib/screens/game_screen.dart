import 'dart:async';
import 'package:flutter/material.dart';
import '../models/candy.dart';
import '../services/game_logic.dart';
import '../widgets/game_grid.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late List<List<Candy?>> _grid;
  late List<Candy> _matchedCandies;
  late int _score;
  late int _level;
  late bool _isAnimating;
  late Timer _animationTimer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _grid = GameLogic.createInitialGrid();
    _matchedCandies = [];
    _score = 0;
    _level = 1;
    _isAnimating = false;
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    super.dispose();
  }

  void _handleSwap(Candy candy1, Candy candy2) {
    if (_isAnimating) return;

    // Check if the swap is valid
    if (!GameLogic.isValidSwap(_grid, candy1.row, candy1.col, candy2.row, candy2.col)) {
      _showInvalidMoveSnackBar();
      return;
    }

    // Perform the swap
    _swapCandies(candy1, candy2);
    
    // Start the match detection and animation sequence
    _processMatches();
  }

  void _swapCandies(Candy candy1, Candy candy2) {
    setState(() {
      // Swap the candies in the grid
      final temp = _grid[candy1.row][candy1.col];
      _grid[candy1.row][candy1.col] = _grid[candy2.row][candy2.col];
      _grid[candy2.row][candy2.col] = temp;

      // Update candy positions
      _grid[candy1.row][candy1.col] = _grid[candy1.row][candy1.col]!.copyWith(
        row: candy1.row,
        col: candy1.col,
      );
      _grid[candy2.row][candy2.col] = _grid[candy2.row][candy2.col]!.copyWith(
        row: candy2.row,
        col: candy2.col,
      );
    });
  }

  void _processMatches() async {
    setState(() {
      _isAnimating = true;
    });

    // Find matches
    final matches = GameLogic.findMatches(_grid);
    
    if (matches.isEmpty) {
      // No matches found, revert the swap
      setState(() {
        _isAnimating = false;
      });
      return;
    }

    // Update score
    final matchScore = GameLogic.calculateScore(matches);
    setState(() {
      _score += matchScore;
      _matchedCandies = matches;
    });

    // Wait for match animation to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Remove matched candies
    setState(() {
      _grid = GameLogic.removeMatches(_grid, matches);
      _matchedCandies = [];
    });

    // Wait for removal animation
    await Future.delayed(const Duration(milliseconds: 300));

    // Drop candies down
    setState(() {
      _grid = GameLogic.dropCandies(_grid);
    });

    // Wait for drop animation
    await Future.delayed(const Duration(milliseconds: 400));

    // Fill empty spaces
    setState(() {
      _grid = GameLogic.fillEmptySpaces(_grid);
    });

    // Wait for fill animation
    await Future.delayed(const Duration(milliseconds: 300));

    // Check for new matches (cascade effect)
    final newMatches = GameLogic.findMatches(_grid);
    if (newMatches.isNotEmpty) {
      _processMatches(); // Recursive call for cascading matches
    } else {
      setState(() {
        _isAnimating = false;
      });
      
      // Check if level should increase
      if (_score >= _level * 100) {
        _levelUp();
      }
    }
  }

  void _levelUp() {
    setState(() {
      _level++;
    });
    _showLevelUpDialog();
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Level Up! 🎉'),
        content: Text('Congratulations! You reached level $_level'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showInvalidMoveSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid move! Try swapping adjacent candies.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Candy Crush DT'),
        backgroundColor: Colors.purple[400],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Reset Game',
          ),
        ],
      ),
      body: Column(
        children: [
          // Score and Level Panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard('Score', _score.toString(), Icons.star, Colors.amber),
                _buildInfoCard('Level', _level.toString(), Icons.trending_up, Colors.green),
              ],
            ),
          ),
          
          // Game Grid
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GameGrid(
                  grid: _grid,
                  onSwap: _handleSwap,
                  matchedCandies: _matchedCandies,
                  isAnimating: _isAnimating,
                ),
              ),
            ),
          ),
          
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: const Column(
              children: [
                Text(
                  'How to Play',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap or drag to swap adjacent candies and create matches of 3 or more!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
} 