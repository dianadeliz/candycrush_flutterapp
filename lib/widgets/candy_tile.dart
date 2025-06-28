import 'package:flutter/material.dart';
import '../models/candy.dart';

class CandyTile extends StatefulWidget {
  final Candy candy;
  final double size;
  final VoidCallback? onTap;
  final Function(Candy) onDragStart;
  final Function(Candy) onDragEnd;
  final bool isSelected;
  final bool isMatched;

  const CandyTile({
    super.key,
    required this.candy,
    required this.size,
    this.onTap,
    required this.onDragStart,
    required this.onDragEnd,
    this.isSelected = false,
    this.isMatched = false,
  });

  @override
  State<CandyTile> createState() => _CandyTileState();
}

class _CandyTileState extends State<CandyTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    if (widget.isMatched) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CandyTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMatched && !oldWidget.isMatched) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: (details) {
        widget.onDragStart(widget.candy);
      },
      onPanEnd: (details) {
        widget.onDragEnd(widget.candy);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? 1.1 : _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: widget.candy.color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(widget.size * 0.2),
                    border: Border.all(
                      color: widget.isSelected
                          ? Colors.white
                          : widget.candy.color.withOpacity(0.5),
                      width: widget.isSelected ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.candy.color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.candy.icon,
                    color: Colors.white,
                    size: widget.size * 0.6,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 