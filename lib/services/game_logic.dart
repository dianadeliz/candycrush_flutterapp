import 'dart:math';
import '../models/candy.dart';

class GameLogic {
  static const int gridSize = 8;
  static const int minMatchLength = 3;

  static List<List<Candy?>> createInitialGrid() {
    final random = Random();
    List<List<Candy?>> grid = List.generate(
      gridSize,
      (row) => List.generate(
        gridSize,
        (col) => Candy(
          type: CandyType.values[random.nextInt(CandyType.values.length)],
          row: row,
          col: col,
        ),
      ),
    );

    // Ensure no initial matches
    while (_hasMatches(grid)) {
      grid = _shuffleGrid(grid);
    }

    return grid;
  }

  static List<List<Candy?>> _shuffleGrid(List<List<Candy?>> grid) {
    final random = Random();
    List<List<Candy?>> newGrid = List.generate(
      gridSize,
      (row) => List.generate(
        gridSize,
        (col) => Candy(
          type: CandyType.values[random.nextInt(CandyType.values.length)],
          row: row,
          col: col,
        ),
      ),
    );
    return newGrid;
  }

  static bool _hasMatches(List<List<Candy?>> grid) {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (_checkHorizontalMatch(grid, row, col).isNotEmpty ||
            _checkVerticalMatch(grid, row, col).isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  static List<Candy> _checkHorizontalMatch(List<List<Candy?>> grid, int row, int col) {
    if (grid[row][col] == null) return [];
    
    final candyType = grid[row][col]!.type;
    List<Candy> matches = [];
    
    // Check to the right
    for (int c = col; c < gridSize; c++) {
      if (grid[row][c]?.type == candyType) {
        matches.add(grid[row][c]!);
      } else {
        break;
      }
    }
    
    // Check to the left
    for (int c = col - 1; c >= 0; c--) {
      if (grid[row][c]?.type == candyType) {
        matches.add(grid[row][c]!);
      } else {
        break;
      }
    }
    
    return matches.length >= minMatchLength ? matches : [];
  }

  static List<Candy> _checkVerticalMatch(List<List<Candy?>> grid, int row, int col) {
    if (grid[row][col] == null) return [];
    
    final candyType = grid[row][col]!.type;
    List<Candy> matches = [];
    
    // Check down
    for (int r = row; r < gridSize; r++) {
      if (grid[r][col]?.type == candyType) {
        matches.add(grid[r][col]!);
      } else {
        break;
      }
    }
    
    // Check up
    for (int r = row - 1; r >= 0; r--) {
      if (grid[r][col]?.type == candyType) {
        matches.add(grid[r][col]!);
      } else {
        break;
      }
    }
    
    return matches.length >= minMatchLength ? matches : [];
  }

  static List<Candy> findMatches(List<List<Candy?>> grid) {
    List<Candy> allMatches = [];
    
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final horizontalMatches = _checkHorizontalMatch(grid, row, col);
        final verticalMatches = _checkVerticalMatch(grid, row, col);
        
        allMatches.addAll(horizontalMatches);
        allMatches.addAll(verticalMatches);
      }
    }
    
    // Remove duplicates
    return allMatches.toSet().toList();
  }

  static bool isValidSwap(List<List<Candy?>> grid, int row1, int col1, int row2, int col2) {
    // Check if positions are adjacent
    if ((row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1)) {
      
      // Create a copy of the grid and swap
      List<List<Candy?>> testGrid = _copyGrid(grid);
      _swapCandies(testGrid, row1, col1, row2, col2);
      
      // Check if the swap creates any matches
      return findMatches(testGrid).isNotEmpty;
    }
    
    return false;
  }

  static List<List<Candy?>> _copyGrid(List<List<Candy?>> grid) {
    return List.generate(
      gridSize,
      (row) => List.generate(
        gridSize,
        (col) => grid[row][col]?.copyWith(),
      ),
    );
  }

  static void _swapCandies(List<List<Candy?>> grid, int row1, int col1, int row2, int col2) {
    final temp = grid[row1][col1];
    grid[row1][col1] = grid[row2][col2];
    grid[row2][col2] = temp;
    
    // Update positions
    if (grid[row1][col1] != null) {
      grid[row1][col1] = grid[row1][col1]!.copyWith(row: row1, col: col1);
    }
    if (grid[row2][col2] != null) {
      grid[row2][col2] = grid[row2][col2]!.copyWith(row: row2, col: col2);
    }
  }

  static List<List<Candy?>> removeMatches(List<List<Candy?>> grid, List<Candy> matches) {
    List<List<Candy?>> newGrid = _copyGrid(grid);
    
    // Mark matched candies for removal
    for (final match in matches) {
      newGrid[match.row][match.col] = null;
    }
    
    return newGrid;
  }

  static List<List<Candy?>> dropCandies(List<List<Candy?>> grid) {
    List<List<Candy?>> newGrid = _copyGrid(grid);
    
    // Drop candies down
    for (int col = 0; col < gridSize; col++) {
      int writeRow = gridSize - 1;
      for (int row = gridSize - 1; row >= 0; row--) {
        if (newGrid[row][col] != null) {
          if (writeRow != row) {
            newGrid[writeRow][col] = newGrid[row][col]!.copyWith(row: writeRow);
            newGrid[row][col] = null;
          }
          writeRow--;
        }
      }
    }
    
    return newGrid;
  }

  static List<List<Candy?>> fillEmptySpaces(List<List<Candy?>> grid) {
    List<List<Candy?>> newGrid = _copyGrid(grid);
    final random = Random();
    
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (newGrid[row][col] == null) {
          newGrid[row][col] = Candy(
            type: CandyType.values[random.nextInt(CandyType.values.length)],
            row: row,
            col: col,
          );
        }
      }
    }
    
    return newGrid;
  }

  static int calculateScore(List<Candy> matches) {
    // Base score per match, bonus for longer matches
    int score = 0;
    for (final candy in matches) {
      score += 10;
    }
    
    // Bonus for longer chains
    if (matches.length >= 5) {
      score += 50; // 5+ match bonus
    } else if (matches.length >= 4) {
      score += 20; // 4 match bonus
    }
    
    return score;
  }
} 