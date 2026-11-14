import 'package:flutter/material.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';

class SplitsySection extends StatelessWidget {
  const SplitsySection({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = breakpointOf(MediaQuery.sizeOf(context).width);
    final tiles = [for (final feature in Profile.splitsyFeatures) _FeatureTile(feature)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(label: 'Featured project', title: 'Splitsy, my app on Google Play'),
        const _Showcase(),
        const SizedBox(height: bentoGap),
        if (bp == Breakpoint.wide) ...[
          BentoRow(flex: const [6, 3, 3], children: [const _CodeTile(), tiles[0], tiles[1]]),
          const SizedBox(height: bentoGap),
          BentoRow(flex: const [1, 1, 1, 1], children: tiles.sublist(2)),
        ] else ...[
          const _CodeTile(),
          for (var i = 0; i < tiles.length; i += 2) ...[
            const SizedBox(height: bentoGap),
            BentoRow(flex: const [1, 1], children: tiles.sublist(i, i + 2)),
          ],
        ],
      ],
    );
  }
}

class _Showcase extends StatelessWidget {
  const _Showcase();

  @override
  Widget build(BuildContext context) {
    final bp = breakpointOf(MediaQuery.sizeOf(context).width);
    final narrow = bp == Breakpoint.narrow;

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('images/splitsy_icon.png', width: 60, height: 60),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Splitsy', style: AppType.display(size: 30, height: 1.05)),
                  const SizedBox(height: 4),
                  Text(
                    'Android  ·  v2.0',
                    style: AppType.mono(size: 11, color: const Color(0xB3FFFFFF)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Split smart.\nSettle with UPI.',
          style: AppType.display(size: narrow ? 40 : 54, height: 1.0),
        ),
        const SizedBox(height: 18),
        Text(
          'Trips, rent and dinners, sorted. Add an expense, split it equally or by exact amounts, and Splitsy works out who owes whom in the fewest payments. Then pay straight from UPI.',
          style: AppType.sans(size: 16, color: const Color(0xE6FFFFFF)),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final s in Profile.splitsyStack)
              Chip2(s, color: Colors.white, border: const Color(0x4DFFFFFF)),
          ],
        ),
        const SizedBox(height: 28),
        PillButton(
          label: 'Get it on Google Play',
          icon: Icons.shop_rounded,
          fill: AppColors.splitsy,
          foreground: AppColors.splitsyInk,
          onPressed: () => openExternal(context, Profile.splitsyPlayStore),
        ),
      ],
    );

    return BentoTile(
      padding: EdgeInsets.all(narrow ? 24 : 44),
      clip: true,
      borderColor: const Color(0xFF1E5A35),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F5A2D), AppColors.splitsyDeep, Color(0xFF07170D)],
        stops: [0, 0.55, 1],
      ),
      child: narrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [copy, const SizedBox(height: 36), const SizedBox(height: 330, child: _Phones())],
            )
          : Row(
              children: [
                Expanded(flex: 6, child: copy),
                const SizedBox(width: 32),
                const Expanded(flex: 6, child: SizedBox(height: 540, child: _Phones())),
              ],
            ),
    );
  }
}

class _Phones extends StatelessWidget {
  const _Phones();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final h = c.maxHeight;
        final w = (h * 9 / 16).clamp(0.0, c.maxWidth / 1.85);
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.translate(
              offset: Offset(-w * 0.42, h * 0.04),
              child: Transform.rotate(
                angle: -0.07,
                child: _Phone('images/splitsy/03_balances.png', width: w * 0.88, dim: true),
              ),
            ),
            Transform.translate(
              offset: Offset(w * 0.42, -h * 0.02),
              child: _Phone('images/splitsy/01_home.png', width: w * 0.92),
            ),
          ],
        );
      },
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone(this.asset, {required this.width, this.dim = false});

  final String asset;
  final double width;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final radius = width * 0.12;
    return Container(
      width: width,
      height: width * 16 / 9,
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: const Color(0xFF050505),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Color(0x80000000), blurRadius: 40, offset: Offset(0, 24)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius * 0.8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(asset, fit: BoxFit.cover, filterQuality: FilterQuality.medium),
            if (dim) const ColoredBox(color: Color(0x33000000)),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile(this.feature);

  final Feature feature;

  static const _icons = <String, IconData>{
    'Fewest payments': Icons.alt_route_rounded,
    'Settle with UPI': Icons.currency_rupee_rounded,
    'Invite by link or QR': Icons.qr_code_2_rounded,
    'Insights': Icons.donut_large_rounded,
    'Recurring expenses': Icons.event_repeat_rounded,
    'Export to PDF or CSV': Icons.ios_share_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x1F1DB954),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icons[feature.title], size: 20, color: AppColors.splitsy),
          ),
          const SizedBox(height: 18),
          Text(feature.title, style: AppType.display(size: 18, height: 1.2)),
          const SizedBox(height: 8),
          Text(feature.detail, style: AppType.sans(size: 13.5, color: AppColors.muted, height: 1.5)),
        ],
      ),
    );
  }
}

class _CodeTile extends StatelessWidget {
  const _CodeTile();

  static const _code = '''List<Debt> simplifyDebts(Map<String, double> balances) {
  // creditors and debtors, largest first, in cents
  while (i < creditors.length && j < debtors.length) {
    final pay = credit < debt ? credit : debt;
    debts.add(Debt(
      from: debtors[j].key,
      to: creditors[i].key,
      amount: pay / 100,
    ));
    credit -= pay;
    debt -= pay;
    if (credit == 0 && ++i < creditors.length) {
      credit = creditors[i].value;
    }
    if (debt == 0 && ++j < debtors.length) {
      debt = debtors[j].value;
    }
  }
  return debts;
}''';

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      padding: EdgeInsets.zero,
      clip: true,
      color: const Color(0xFF0C0F0D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              children: [
                for (final c in const [Color(0xFFFF5F57), Color(0xFFFEBC2E), Color(0xFF28C840)]) ...[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                ],
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'lib/utils/balances.dart',
                    overflow: TextOverflow.ellipsis,
                    style: AppType.mono(size: 11, letterSpacing: 0.3),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(20),
            child: Text(
              _code,
              style: AppType.mono(
                size: 12.5,
                color: const Color(0xFFB8E8C8),
                letterSpacing: 0,
              ).copyWith(height: 1.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: Text(
              'Amounts are settled in whole cents, so splits always add up exactly.',
              style: AppType.sans(size: 13, color: AppColors.muted, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
