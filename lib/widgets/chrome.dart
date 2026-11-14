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
    this.tint,
  });

  final Widget child;
  final ValueChanged<bool>? onHover;

  /// Color of the hover circle's difference blend. Leave null (white) for
  /// neutral targets; pass the target's own fill color for colored ones, since
  /// white over a saturated fill inverts to its complement.
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: interactiveCursor,
      onEnter: (_) {
        Hovering.hovering = true;
        Hovering.tint = tint ?? Colors.white;
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
  const PageFrame({super.key, required this.child, this.maxWidth = 1200});

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

/// Lays children out side by side on wide screens with equal heights, and
/// stacks them on narrow screens. [flex] pairs with [children] by index.
class BentoRow extends StatelessWidget {
  const BentoRow({
    super.key,
    required this.children,
    required this.flex,
    this.stackBelow = Breakpoint.medium,
  });

  final List<Widget> children;
  final List<int> flex;
  final Breakpoint stackBelow;

  @override
  Widget build(BuildContext context) {
    final bp = breakpointOf(MediaQuery.sizeOf(context).width);
    if (bp.index < stackBelow.index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: bentoGap),
            children[i],
          ],
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: bentoGap),
            Expanded(flex: flex[i], child: children[i]),
          ],
        ],
      ),
    );
  }
}

class BentoTile extends StatefulWidget {
  const BentoTile({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    this.color = AppColors.tile,
    this.gradient,
    this.borderColor = AppColors.line,
    this.hoverBorder = AppColors.lineHi,
    this.clip = false,
    this.tint,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color color;
  final Gradient? gradient;
  final Color borderColor;
  final Color hoverBorder;
  final bool clip;
  final Color? tint;

  @override
  State<BentoTile> createState() => _BentoTileState();
}

class _BentoTileState extends State<BentoTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final interactive = widget.onTap != null;
    Widget tile = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      clipBehavior: widget.clip ? Clip.antiAlias : Clip.none,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _hover && interactive ? widget.hoverBorder : widget.borderColor,
        ),
      ),
      child: widget.child,
    );

    if (!interactive) return tile;

    tile = AnimatedScale(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      scale: _hover ? 1.012 : 1,
      child: tile,
    );
    return PointerTarget(
      tint: widget.tint,
      onHover: (value) => setState(() => _hover = value),
      child: GestureDetector(onTap: widget.onTap, child: tile),
    );
  }
}

class TileLabel extends StatelessWidget {
  const TileLabel(this.text, {super.key, this.color = AppColors.muted});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppType.mono(size: 11, color: color));
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.label, required this.title});

  final String label;
  final String title;

  @override
  Widget build(BuildContext context) {
    final narrow = breakpointOf(MediaQuery.sizeOf(context).width) == Breakpoint.narrow;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TileLabel(label, color: AppColors.accent),
          const SizedBox(height: 10),
          Text(title, style: AppType.display(size: narrow ? 30 : 40)),
        ],
      ),
    );
  }
}

class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fill,
    this.foreground,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;

  /// Null draws an outlined button.
  final Color? fill;
  final Color? foreground;
  final IconData? icon;

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final fill = widget.fill;
    final fg = widget.foreground ?? (fill == null ? AppColors.ink : AppColors.bg);
    final background = fill == null
        ? (_hover ? AppColors.tileHi : Colors.transparent)
        : Color.lerp(fill, Colors.white, _hover ? 0.12 : 0)!;

    return PointerTarget(
      tint: fill,
      onHover: (value) => setState(() => _hover = value),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: fill ?? AppColors.lineHi),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.sans(
                    size: 14,
                    weight: FontWeight.w600,
                    color: fg,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Chip2 extends StatelessWidget {
  const Chip2(this.label, {super.key, this.color = AppColors.body, this.border = AppColors.line});

  final String label;
  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(label, style: AppType.sans(size: 12.5, color: color, height: 1.2)),
    );
  }
}

class LiveDot extends StatefulWidget {
  const LiveDot({super.key, this.color = AppColors.signal});

  final Color color;

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
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
