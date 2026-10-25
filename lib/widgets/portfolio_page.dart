import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';
import 'package:my_portfolio/widgets/contact_section.dart';
import 'package:my_portfolio/widgets/experience_section.dart';
import 'package:my_portfolio/widgets/skills_section.dart';
import 'package:my_portfolio/widgets/work_section.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  final _workKey = GlobalKey();
  final _experienceKey = GlobalKey();
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
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
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
    final target = key.currentContext;
    final object = target?.findRenderObject();
    if (object == null || !_scroll.hasClients) return;
    final viewport = RenderAbstractViewport.of(object);
    final reveal = viewport.getOffsetToReveal(object, 0).offset;
    final destination = (reveal - 84).clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.animateTo(
      destination,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 760;
    final heroWide = width >= 980;

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
                    SizedBox(height: compact ? 88 : 96),
                    PageFrame(
                      child: FadeTransition(
                        opacity: CurvedAnimation(parent: _enter, curve: Curves.easeOut),
                        child: Stack(
                          children: [
                            const Positioned.fill(child: FadingGrid()),
                            _Hero(wide: heroWide),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 72 : 108),
                    PageFrame(child: _About(wide: width >= 860)),
                    SizedBox(height: compact ? 80 : 120),
                    PageFrame(child: WorkSection(key: _workKey)),
                    SizedBox(height: compact ? 80 : 120),
                    PageFrame(child: ExperienceSection(key: _experienceKey)),
                    SizedBox(height: compact ? 80 : 120),
                    PageFrame(child: SkillsSection(key: _skillsKey)),
                    SizedBox(height: compact ? 80 : 120),
                    const PageFrame(child: EarlierWorkSection()),
                    SizedBox(height: compact ? 80 : 120),
                    PageFrame(child: ContactSection(key: _contactKey)),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _Nav(
              scrolled: _scrolled,
              compact: compact,
              menuOpen: _menuOpen,
              onMenu: () => setState(() => _menuOpen = !_menuOpen),
              onWork: () => _go(_workKey),
              onExperience: () => _go(_experienceKey),
              onSkills: () => _go(_skillsKey),
              onContact: () => _go(_contactKey),
            ),
          ),
          if (_menuOpen && compact)
            Positioned.fill(
              top: 64,
              child: _MobileMenu(
                onWork: () => _go(_workKey),
                onExperience: () => _go(_experienceKey),
                onSkills: () => _go(_skillsKey),
                onContact: () => _go(_contactKey),
                onClose: () => setState(() => _menuOpen = false),
              ),
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
    required this.onMenu,
    required this.onWork,
    required this.onExperience,
    required this.onSkills,
    required this.onContact,
  });

  final bool scrolled;
  final bool compact;
  final bool menuOpen;
  final VoidCallback onMenu;
  final VoidCallback onWork;
  final VoidCallback onExperience;
  final VoidCallback onSkills;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final showEmail = MediaQuery.sizeOf(context).width >= 1080;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: const BorderSide(color: AppColors.copper, width: 2),
          bottom: BorderSide(color: scrolled || menuOpen ? AppColors.line : Colors.transparent),
        ),
      ),
      child: PageFrame(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Text('AP', style: AppType.serif(size: 22, letterSpacing: -0.6)),
              const SizedBox(width: 10),
              Text(
                Profile.name,
                style: AppType.sans(size: 14, weight: FontWeight.w600, color: AppColors.ink, height: 1),
              ),
              const Spacer(),
              if (!compact) ...[
                _NavLink('Work', onWork),
                _NavLink('Experience', onExperience),
                _NavLink('Skills', onSkills),
                _NavLink('Contact', onContact),
                if (showEmail) ...[
                  const SizedBox(width: 8),
                  AppButton(
                    label: 'Email',
                    filled: true,
                    onPressed: () => openExternal(context, Profile.mailUri),
                  ),
                ],
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
        ),
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
      accent: true,
      onHover: (value) => setState(() => _hover = value),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            widget.label,
            style: AppType.sans(
              size: 14,
              weight: FontWeight.w500,
              height: 1.1,
              color: _hover ? AppColors.copper : AppColors.body,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({
    required this.onWork,
    required this.onExperience,
    required this.onSkills,
    required this.onContact,
    required this.onClose,
  });

  final VoidCallback onWork;
  final VoidCallback onExperience;
  final VoidCallback onSkills;
  final VoidCallback onContact;
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
              _MenuItem('Work', onWork),
              _MenuItem('Experience', onExperience),
              _MenuItem('Skills', onSkills),
              _MenuItem('Contact', onContact),
              const SizedBox(height: 12),
              AppButton(
                label: 'Email ${Profile.email}',
                filled: true,
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

class _MenuItem extends StatelessWidget {
  const _MenuItem(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PointerTarget(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(label, style: AppType.serif(size: 36, letterSpacing: -0.8)),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DATA ENGINEERING  ·  CLOUD PLATFORMS',
          style: AppType.mono(size: 11, color: AppColors.copper, letterSpacing: 1.6),
        ),
        const SizedBox(height: 18),
        Text(
          Profile.name,
          style: AppType.sans(size: 16, weight: FontWeight.w600, color: AppColors.ink, height: 1),
        ),
        const SizedBox(height: 6),
        Text(
          '${Profile.role} at ${Profile.company}, ${Profile.city}',
          style: AppType.sans(size: 15, color: AppColors.muted, height: 1.3),
        ),
        const SizedBox(height: 22),
        Text.rich(
          TextSpan(
            style: AppType.serif(
              size: headlineSize(width),
              height: 0.96,
              letterSpacing: -1.8,
              weight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: 'Enterprise data,\n'),
              TextSpan(
                text: 'built to be trusted.',
                style: AppType.serif(
                  size: headlineSize(width),
                  height: 0.96,
                  letterSpacing: -1.8,
                  weight: FontWeight.w500,
                  style: FontStyle.italic,
                  color: AppColors.copper,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'I architect pipelines on Azure Databricks and Snowflake, automate batch and streaming with Delta Live Tables, and govern access in Unity Catalog. Then I open Spark UI and take the waste out of the job.',
            style: AppType.sans(size: 16.5, color: AppColors.body),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Based in Kerala  ·  Open to Pune, Hyderabad, Bengaluru, and Chennai',
          style: AppType.sans(size: 14, color: AppColors.muted, height: 1.4),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(
              label: 'Start a conversation',
              filled: true,
              onPressed: () => openExternal(context, Profile.mailUri),
            ),
            AppButton(
              label: 'GitHub',
              onPressed: () => openExternal(context, Profile.github),
            ),
          ],
        ),
      ],
    );

    const panel = _LakehousePanel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 6, child: copy),
              const SizedBox(width: 48),
              const Expanded(flex: 5, child: panel),
            ],
          )
        else ...[
          copy,
          const SizedBox(height: 36),
          panel,
        ],
        const SizedBox(height: 42),
        const _StatStrip(),
      ],
    );
  }
}

class _LakehousePanel extends StatelessWidget {
  const _LakehousePanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF14120E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'MEDALLION LAKEHOUSE',
                  style: AppType.mono(size: 11, color: AppColors.muted, letterSpacing: 1.2),
                ),
                const Spacer(),
                const LiveDot(),
                const SizedBox(width: 8),
                Text(
                  'HOW I BUILD',
                  style: AppType.mono(size: 11, color: AppColors.signal, letterSpacing: 1.1),
                ),
              ],
            ),
            const SizedBox(height: 18),
            for (var i = 0; i < Profile.stages.length; i++)
              _StageRow(stage: Profile.stages[i], last: i == Profile.stages.length - 1),
            const SizedBox(height: 8),
            const Divider(height: 1, color: AppColors.line),
            const SizedBox(height: 14),
            Text(
              'Databricks for the compute. Delta Live Tables for the flow. Unity Catalog for who can see it. Snowflake for the people asking questions.',
              style: AppType.sans(size: 13.5, color: AppColors.muted, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow({required this.stage, required this.last});

  final Stage stage;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 4 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: last ? AppColors.copper : Colors.transparent,
                    border: Border.all(color: AppColors.copper, width: 1.4),
                  ),
                ),
                if (!last)
                  Container(
                    width: 1,
                    height: 26,
                    margin: const EdgeInsets.only(top: 4),
                    color: AppColors.line,
                  ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    stage.title,
                    style: AppType.sans(
                      size: 15,
                      weight: FontWeight.w600,
                      color: AppColors.ink,
                      height: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    stage.detail,
                    style: AppType.sans(size: 13.5, color: AppColors.muted, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatStrip extends StatelessWidget {
  const _StatStrip();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final stats = [for (final stat in Profile.stats) _StatCell(stat)];

    if (!wide) {
      return Column(
        children: [
          Row(children: [Expanded(child: stats[0]), Expanded(child: stats[1])]),
          Row(children: [Expanded(child: stats[2]), Expanded(child: stats[3])]),
        ],
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.line),
          bottom: BorderSide(color: AppColors.line),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < stats.length; i++)
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: i == 0 ? Colors.transparent : AppColors.line),
                    ),
                  ),
                  child: stats[i],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell(this.stat);

  final Stat stat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.value,
            style: AppType.serif(size: 28, height: 1, letterSpacing: -0.6),
          ),
          const SizedBox(height: 6),
          Text(stat.label, style: AppType.sans(size: 13, color: AppColors.muted, height: 1.35)),
        ],
      ),
    );
  }
}

class _About extends StatelessWidget {
  const _About({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final portrait = ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Image.asset(
          'images/dp.jpeg',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          semanticLabel: 'Portrait of Arun Prakash',
        ),
      ),
    );

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ABOUT', style: AppType.mono(size: 12, color: AppColors.copper)),
        const SizedBox(height: 12),
        Text(
          'A data engineer who still likes the unglamorous parts.',
          style: AppType.serif(
            size: wide ? 42 : 34,
            height: 1.05,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'I have spent more than three years inside enterprise data at Amdocs. The job is the platform: pipelines that keep running, tables people can trust, and compute that is not on fire.',
          style: AppType.sans(size: 16.5, color: AppColors.body),
        ),
        const SizedBox(height: 14),
        Text(
          'Day to day that means lakehouse design on Azure Databricks and Snowflake, Delta Live Tables for batch and streaming, Unity Catalog for access and metadata, and Spark tuning when a stage is shuffling itself into a corner. I also mentor junior engineers, and I stay in the room with stakeholders until the dataset answers a real question.',
          style: AppType.sans(size: 16.5, color: AppColors.body),
        ),
        const SizedBox(height: 22),
        Text(
          'B.Tech, Electronics and Telecommunication  ·  VIT  ·  2023',
          style: AppType.mono(size: 11, color: AppColors.faint, letterSpacing: 0.6),
        ),
      ],
    );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          copy,
          const SizedBox(height: 28),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                portrait,
                const SizedBox(height: 10),
                Text(
                  'KERALA',
                  style: AppType.mono(size: 11, color: AppColors.faint, letterSpacing: 1.4),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              portrait,
              const SizedBox(height: 10),
              Text(
                'KERALA',
                style: AppType.mono(size: 11, color: AppColors.faint, letterSpacing: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 56),
        Expanded(flex: 7, child: copy),
      ],
    );
  }
}
