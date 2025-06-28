import 'package:flutter/material.dart';
import '../models/candy.dart';
import '../services/game_logic.dart';
import 'candy_tile.dart';

class GameGrid extends StatefulWidget {
  final List<List<Candy?>> grid;
  final Function(Candy, Candy) onSwap;
  final List<Candy> matchedCandies;
  final bool isAnimating;

  const GameGrid({
    super.key,
    required this.grid,
    required this.onSwap,
    required this.matchedCandies,
    this.isAnimating = false,
  });

  @override
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  Candy? selectedCandy;
  Candy? draggedCandy;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final gridSize = screenSize.width * 0.9;
    final tileSize = gridSize / GameLogic.gridSize;

    return Container(
      width: gridSize,
      height: gridSize,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!, width: 2),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: GameLogic.gridSize,
          childAspectRatio: 1.0,
        ),
        itemCount: GameLogic.gridSize * GameLogic.gridSize,
        itemBuilder: (context, index) {
          final row = index ~/ GameLogic.gridSize;
          final col = index % GameLogic.gridSize;
          final candy = widget.grid[row][col];

          if (candy == null) {
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(tileSize * 0.2),
              ),
            );
          }

          final isMatched = widget.matchedCandies.contains(candy);
          final isSelected = selectedCandy == candy;

          return CandyTile(
            candy: candy,
            size: tileSize - 4,
            isSelected: isSelected,
            isMatched: isMatched,
            onTap: () => _handleTap(candy),
            onDragStart: (candy) => _handleDragStart(candy),
            onDragEnd: (candy) => _handleDragEnd(candy),
          );
        },
      ),
    );
  }

  void _handleTap(Candy candy) {
    if (widget.isAnimating) return;

    setState(() {
      if (selectedCandy == candy) {
        selectedCandy = null;
      } else if (selectedCandy != null) {
        // Try to swap with selected candy
        if (_canSwap(selectedCandy!, candy)) {
          widget.onSwap(selectedCandy!, candy);
          selectedCandy = null;
        } else {
          selectedCandy = candy;
        }
      } else {
        selectedCandy = candy;
      }
    });
  }

  void _handleDragStart(Candy candy) {
    if (widget.isAnimating) return;
    setState(() {
      draggedCandy = candy;
    });
  }

  void _handleDragEnd(Candy candy) {
    if (widget.isAnimating || draggedCandy == null) return;

    // Find the candy that was dragged to
    final dragEndCandy = _findCandyAtPosition(candy);
    if (dragEndCandy != null && dragEndCandy != draggedCandy) {
      if (_canSwap(draggedCandy!, dragEndCandy)) {
        widget.onSwap(draggedCandy!, dragEndCandy);
      }
    }

    setState(() {
      draggedCandy = null;
      selectedCandy = null;
    });
  }

  Candy? _findCandyAtPosition(Candy candy) {
    // This is a simplified version - in a real implementation,
    // you'd use the actual drag position to determine which candy was targeted
    return candy;
  }

  bool _canSwap(Candy candy1, Candy candy2) {
    // Check if candies are adjacent
    final rowDiff = (candy1.row - candy2.row).abs();
    final colDiff = (candy1.col - candy2.col).abs();
    
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }
} 