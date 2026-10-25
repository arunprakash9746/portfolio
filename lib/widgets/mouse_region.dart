import 'package:flutter/material.dart';
import 'package:my_portfolio/config/Hovering.dart';
import 'package:my_portfolio/config/Pointer.dart';
import 'package:my_portfolio/widgets/portfolio_page.dart';

class Mouse extends StatefulWidget {
  const Mouse({super.key});

  @override
  State<Mouse> createState() => _MouseState();
}

class _MouseState extends State<Mouse> with TickerProviderStateMixin {
  Offset? pointer = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: (eve) {
        setState(() {
          pointer = eve.position;
        });
      },
      onEnter: (eve) {
        setState(() {
          pointer = eve.position;
        });
      },
      child: Stack(
        children: [
          DefaultSelectionStyle.merge(
            mouseCursor: SystemMouseCursors.none,
            child: const PortfolioPage(),
          ),
          AnimatedPointer(
            pointerOffset: pointer!,
            radius: 20,
          ),
          if (!Hovering.hovering) ...[
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1),
              curve: Curves.easeOutExpo,
              top: pointer?.dy,
              left: pointer?.dx,
              child: CustomPaint(
                painter: Pointer(2),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class AnimatedPointer extends StatelessWidget {
  const AnimatedPointer({
    super.key,
    this.movementDuration = const Duration(milliseconds: 500),
    this.radius = 30,
    required this.pointerOffset,
  });
  final Duration movementDuration;
  final Offset pointerOffset;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: movementDuration,
      curve: Curves.easeOutExpo,
      top: pointerOffset.dy,
      left: pointerOffset.dx,
      child: CustomPaint(
        painter: Hovering.hovering
            ? Pointer(radius, color: Hovering.tint)
            : HoverPointer(radius),
      ),
    );
  }
}
