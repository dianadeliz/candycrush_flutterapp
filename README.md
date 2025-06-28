# Candy Crush

A Flutter implementation of a Candy Crush-style match-3 puzzle game with smooth animations and modern UI.

## Features

### Core Gameplay
- **8x8 Dynamic Grid**: Colorful candy tiles with unique icons and colors
- **Drag-to-Swap**: Intuitive touch controls for swapping adjacent candies
- **Match Detection**: Automatic detection of 3+ matching candies in rows and columns
- **Cascade Effects**: Multiple matches trigger automatically for combo effects

### Animations & Visual Effects
- **Rotation Animation**: Matched candies rotate before disappearing
- **Drop Animation**: Candies fall down to fill empty spaces
- **Fill Animation**: New candies appear at the top with smooth transitions
- **Visual Feedback**: Selected candies scale up and have highlighted borders

### Game Features
- **Score System**: Points awarded for matches with bonuses for longer chains
- **Level Progression**: Automatic level-ups based on score milestones
- **Game Reset**: Easy restart functionality
- **Invalid Move Detection**: Prevents invalid swaps with user feedback

### Technical Features
- **Null Safety**: Full Dart null safety implementation
- **Modular Architecture**: Separated game logic, UI components, and models
- **Responsive Design**: Adapts to different screen sizes
- **Smooth Performance**: Optimized animations and state management

## Game Mechanics

### Candy Types
- **Red**: Heart icon
- **Blue**: Water drop icon  
- **Green**: Eco/leaf icon
- **Yellow**: Star icon
- **Purple**: Diamond icon
- **Orange**: Fire icon

### Scoring System
- Base score: 10 points per matched candy
- 4-match bonus: +20 points
- 5+ match bonus: +50 points

### Level Progression
- Level up every 100 points
- Each level increases the challenge

## How to Play

1. **Swap Candies**: Tap or drag to swap adjacent candies
2. **Create Matches**: Align 3 or more of the same candy type horizontally or vertically
3. **Watch Combos**: Multiple matches trigger automatically for higher scores
4. **Progress**: Earn points to level up and unlock new challenges

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── candy.dart           # Candy model and types
├── services/
│   └── game_logic.dart      # Core game logic and algorithms
├── screens/
│   └── game_screen.dart     # Main game screen
└── widgets/
    ├── candy_tile.dart      # Individual candy tile widget
    └── game_grid.dart       # Game grid container
```

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd candycrush_dt
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the game:
```bash
flutter run
```

### Building for Production

For Android:
```bash
flutter build apk --release
```

For iOS:
```bash
flutter build ios --release
```

For Web:
```bash
flutter build web --release
```

## Technical Implementation

### Architecture
- **Model-View-Service**: Clean separation of concerns
- **State Management**: Flutter's built-in setState for simple state management
- **Animation System**: Custom animation controllers for smooth transitions

### Key Algorithms
- **Match Detection**: Efficient horizontal and vertical pattern matching
- **Grid Management**: Dynamic grid updates with position tracking
- **Cascade Processing**: Recursive match detection for combo effects

### Performance Optimizations
- Efficient grid operations with minimal object creation
- Optimized animation controllers with proper disposal
- Responsive UI with adaptive sizing

## Future Enhancements

- [ ] Sound effects and background music
- [ ] Power-ups and special candies
- [ ] Time-based challenges
- [ ] Multiplayer support
- [ ] Achievement system
- [ ] Custom themes and candy sets
- [ ] Save/load game progress
- [ ] Tutorial mode for beginners

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by the classic Candy Crush Saga game
- Built with Flutter for cross-platform compatibility
- Uses Material Design principles for modern UI/UX

<img width="524" alt="Screenshot 2025-06-28 at 4 50 08 PM" src="https://github.com/user-attachments/assets/8b1e0d2d-bd40-4b4f-9a67-fa8a86ba51db" />

