import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';
import 'package:my_portfolio/widgets/hero_bento.dart';
import 'package:my_portfolio/widgets/more_bento.dart';
import 'package:my_portfolio/widgets/splitsy_section.dart';
import 'package:my_portfolio/widgets/work_bento.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  final _workKey = GlobalKey();
  final _splitsyKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  late final AnimationController _enter;
  bool _scrolled = false;
  bool _menuOpen = false;
  bool _userScrolled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _enter = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    if (WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations) {
      _enter.value = 1;
    } else {
      _enter.forward();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients || _userScrolled) return;
      if (_scroll.offset > 8) _scroll.jumpTo(0);
    });
  }

  void _onScroll() {
    if (_scroll.position.userScrollDirection != ScrollDirection.idle) {
      _userScrolled = true;
    }
    final next = _scroll.offset > 8;
    if (next != _scrolled) setState(() => _scrolled = next);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _enter.dispose();
    super.dispose();
  }

  void _go(GlobalKey key) {
    _userScrolled = true;
    setState(() => _menuOpen = false);
    final object = key.currentContext?.findRenderObject();
    if (object == null || !_scroll.hasClients) return;
    final reveal = RenderAbstractViewport.of(object).getOffsetToReveal(object, 0).offset;
    final destination = (reveal - 96).clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.animateTo(
      destination,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _reveal(int order, Widget child) {
    final start = (order * 0.12).clamp(0.0, 0.6);
    final curve = CurvedAnimation(
      parent: _enter,
      curve: Interval(start, start + 0.4, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(curve),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = breakpointOf(width) == Breakpoint.narrow;
    final gap = compact ? 72.0 : 112.0;
    final links = <(String, VoidCallback)>[
      ('Work', () => _go(_workKey)),
      ('Splitsy', () => _go(_splitsyKey)),
      ('Skills', () => _go(_skillsKey)),
      ('Contact', () => _go(_contactKey)),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          SelectionArea(
            child: AbsorbPointer(
              absorbing: _menuOpen,
              child: Scrollbar(
                controller: _scroll,
                thumbVisibility: !compact,
                child: SingleChildScrollView(
                  controller: _scroll,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: compact ? 84 : 104),
                      PageFrame(
                        child: _reveal(0, HeroBento(onSplitsy: () => _go(_splitsyKey))),
                      ),
                      SizedBox(height: gap),
                      PageFrame(child: _reveal(2, WorkBento(key: _workKey))),
                      SizedBox(height: gap),
                      PageFrame(child: SplitsySection(key: _splitsyKey)),
                      SizedBox(height: gap),
                      PageFrame(child: SkillsBento(key: _skillsKey)),
                      SizedBox(height: gap),
                      const PageFrame(child: EarlierBento()),
                      SizedBox(height: gap),
                      PageFrame(child: ContactBento(key: _contactKey)),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: compact ? 12 : 18,
            left: 0,
            right: 0,
            child: PageFrame(
              child: _Nav(
                scrolled: _scrolled,
                compact: compact,
                menuOpen: _menuOpen,
                links: links,
                onMenu: () => setState(() => _menuOpen = !_menuOpen),
                onTop: () {
                  _userScrolled = true;
                  _scroll.animateTo(0, duration: const Duration(milliseconds: 700), curve: Curves.easeOutCubic);
                },
              ),
            ),
          ),
          if (_menuOpen && compact)
            Positioned.fill(
              top: 76,
              child: _MobileMenu(links: links, onClose: () => setState(() => _menuOpen = false)),
            ),
        ],
      ),
    );
  }
}

class _Nav extends StatelessWidget {
  const _Nav({
    required this.scrolled,
    required this.compact,
    required this.menuOpen,
    required this.links,
    required this.onMenu,
    required this.onTop,
  });

  final bool scrolled;
  final bool compact;
  final bool menuOpen;
  final List<(String, VoidCallback)> links;
  final VoidCallback onMenu;
  final VoidCallback onTop;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 56,
      padding: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        color: scrolled || menuOpen ? const Color(0xF2131316) : const Color(0x00131316),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: scrolled || menuOpen ? AppColors.line : const Color(0x0024242A),
        ),
      ),
      child: Row(
        children: [
          PointerTarget(
            child: GestureDetector(
              onTap: onTop,
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                    child: Text(
                      'AP',
                      style: AppType.display(size: 14, color: AppColors.accentInk, letterSpacing: 0),
                    ),
                  ),
                  if (compact || MediaQuery.sizeOf(context).width >= 1024) ...[
                    const SizedBox(width: 10),
                    Text(
                      Profile.name,
                      style: AppType.sans(size: 14, weight: FontWeight.w600, color: AppColors.ink, height: 1),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Spacer(),
          if (!compact) ...[
            for (final (label, onTap) in links) _NavLink(label, onTap),
            const SizedBox(width: 8),
            PillButton(
              label: 'Email',
              fill: AppColors.ink,
              foreground: AppColors.bg,
              onPressed: () => openExternal(context, Profile.mailUri),
            ),
          ] else
            PointerTarget(
              child: IconButton(
                tooltip: menuOpen ? 'Close menu' : 'Open menu',
                mouseCursor: interactiveCursor,
                onPressed: onMenu,
                icon: Icon(menuOpen ? Icons.close : Icons.menu, color: AppColors.ink),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return PointerTarget(
      onHover: (value) => setState(() => _hover = value),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: _hover ? AppColors.tileHi : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            widget.label,
            style: AppType.sans(
              size: 14,
              weight: FontWeight.w500,
              height: 1.1,
              color: _hover ? AppColors.ink : AppColors.body,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.links, required this.onClose});

  final List<(String, VoidCallback)> links;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: SizedBox.expand(
        child: PageFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              for (final (label, onTap) in links)
                PointerTarget(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                      child: Text(label, style: AppType.display(size: 36)),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              PillButton(
                label: 'Email ${Profile.email}',
                fill: AppColors.accent,
                foreground: AppColors.accentInk,
                onPressed: () {
                  onClose();
                  openExternal(context, Profile.mailUri);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
