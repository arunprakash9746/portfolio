import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/config/Hovering.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

const MouseCursor interactiveCursor =
    kIsWeb ? SystemMouseCursors.none : SystemMouseCursors.click;

class PointerTarget extends StatelessWidget {
  const PointerTarget({
    super.key,
    required this.child,
    this.onHover,
    this.accent = false,
  });

  final Widget child;
  final ValueChanged<bool>? onHover;

  /// Set for targets that are copper (or turn copper on hover). A white
  /// difference blend turns copper blue; a copper one gives dark-on-copper.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: interactiveCursor,
      onEnter: (_) {
        Hovering.hovering = true;
        Hovering.tint = accent ? AppColors.copper : Colors.white;
        onHover?.call(true);
      },
      onExit: (_) {
        Hovering.hovering = false;
        onHover?.call(false);
      },
      child: child,
    );
  }
}

Future<void> openExternal(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  final web = uri.scheme == 'http' || uri.scheme == 'https';
  final opened = await launchUrl(
    uri,
    mode: web ? LaunchMode.externalApplication : LaunchMode.platformDefault,
  );
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $url')),
    );
  }
}

class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.child, this.maxWidth = 1120});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pagePadding(width)),
          child: child,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.index,
    required this.title,
    this.lede,
  });

  final String index;
  final String title;
  final String? lede;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(index, style: AppType.mono(color: AppColors.copper, size: 12)),
        const SizedBox(height: 10),
        Text(
          title,
          style: AppType.serif(
            size: width < 720 ? 36 : 48,
            height: 1.02,
            letterSpacing: -1.1,
          ),
        ),
        if (lede != null) ...[
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(lede!, style: AppType.sans(size: 16, color: AppColors.muted)),
          ),
        ],
      ],
    );
  }
}

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final filled = widget.filled;
    final background = filled
        ? (_hover ? const Color(0xFFF0B56E) : AppColors.copper)
        : (_hover ? AppColors.raised : Colors.transparent);
    final foreground = filled ? AppColors.copperInk : AppColors.ink;

    return PointerTarget(
      accent: filled,
      onHover: (value) => setState(() => _hover = value),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: filled ? background : AppColors.line),
          ),
          child: Text(
            widget.label,
            style: AppType.sans(
              size: 14,
              weight: FontWeight.w600,
              color: foreground,
              height: 1.1,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class HoverPanel extends StatefulWidget {
  const HoverPanel({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<HoverPanel> createState() => _HoverPanelState();
}

class _HoverPanelState extends State<HoverPanel> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return PointerTarget(
      onHover: (value) => setState(() => _hover = value),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.raised,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _hover ? AppColors.copper : AppColors.line,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class Tag extends StatelessWidget {
  const Tag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      child: Text(label, style: AppType.mono(size: 11, letterSpacing: 0.4)),
    );
  }
}

class FadingGrid extends StatelessWidget {
  const FadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x22E2A15C), Color(0x000C0B09)],
            stops: [0, 0.72],
          ),
        ),
        child: CustomPaint(painter: _GridPainter(), child: SizedBox.expand()),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x14F6F1E7)
      ..strokeWidth = 1;
    const gap = 80.0;
    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LiveDot extends StatefulWidget {
  const LiveDot({super.key});

  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations) {
      _controller.value = 1;
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: AppColors.signal,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
