import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class GachaButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const GachaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 140,
    this.height = 60,
  });

  @override
  State<GachaButton> createState() => _GachaButtonState();
}

class _GachaButtonState extends State<GachaButton> {
  bool _isPressed = false;

  void _handleTap(bool pressed) => setState(() => _isPressed = pressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTap(true),
      onTapUp: (_) => _handleTap(false),
      onTapCancel: () => _handleTap(false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.gachaButton,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.gachaButton.withValues(
                  alpha: _isPressed ? 0.1 : 0.3,
                ),
                blurRadius: _isPressed ? 4 : 12,
                offset: _isPressed ? const Offset(0, 2) : const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}