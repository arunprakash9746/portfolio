import 'package:flutter/material.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';

class HeroBento extends StatelessWidget {
  const HeroBento({super.key, required this.onSplitsy});

  final VoidCallback onSplitsy;

  @override
  Widget build(BuildContext context) {
    final bp = breakpointOf(MediaQuery.sizeOf(context).width);
    final stats = [
      const _YearsTile(),
      const _CertTile(),
      _SplitsyTeaser(onTap: onSplitsy),
      const _LocationTile(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BentoRow(
          flex: [8, 4],
          children: [_IntroTile(), _PortraitTile()],
        ),
        const SizedBox(height: bentoGap),
        if (bp == Breakpoint.wide)
          BentoRow(flex: const [3, 4, 3, 3], children: stats)
        else ...[
          BentoRow(flex: const [1, 1], children: stats.sublist(0, 2)),
          const SizedBox(height: bentoGap),
          BentoRow(flex: const [1, 1], children: stats.sublist(2)),
        ],
      ],
    );
  }
}

class _IntroTile extends StatelessWidget {
  const _IntroTile();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bp = breakpointOf(width);
    final headline = switch (bp) {
      Breakpoint.wide => 68.0,
      Breakpoint.medium => 54.0,
      Breakpoint.narrow => width < 400 ? 38.0 : 44.0,
    };

    return BentoTile(
      padding: EdgeInsets.all(bp == Breakpoint.narrow ? 24 : 36),
      gradient: const RadialGradient(
        center: Alignment(-0.9, -1.1),
        radius: 1.4,
        colors: [Color(0x26FFB547), Color(0x00131316)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const LiveDot(),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Open to data engineering roles',
                  style: AppType.sans(size: 13, color: AppColors.body, height: 1.2),
                ),
              ),
            ],
          ),
          SizedBox(height: bp == Breakpoint.narrow ? 36 : 56),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Profile.name}  ·  ${Profile.role} at ${Profile.company}',
                style: AppType.mono(size: 12, color: AppColors.accent, letterSpacing: 0.6),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: AppType.display(size: headline, height: 0.98),
                  children: [
                    const TextSpan(text: 'I build data platforms enterprises can '),
                    TextSpan(
                      text: 'trust.',
                      style: AppType.display(
                        size: headline,
                        height: 0.98,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Lakehouse pipelines on Azure Databricks and Snowflake, batch and streaming with Delta Live Tables, governance in Unity Catalog, and Spark jobs tuned until the waste is gone.',
                style: AppType.sans(size: 16, color: AppColors.body),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  PillButton(
                    label: 'Email me',
                    icon: Icons.arrow_outward_rounded,
                    fill: AppColors.accent,
                    foreground: AppColors.accentInk,
                    onPressed: () => openExternal(context, Profile.mailUri),
                  ),
                  PillButton(
                    label: 'GitHub',
                    onPressed: () => openExternal(context, Profile.github),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PortraitTile extends StatelessWidget {
  const _PortraitTile();

  @override
  Widget build(BuildContext context) {
    final narrow = breakpointOf(MediaQuery.sizeOf(context).width) == Breakpoint.narrow;
    return SizedBox(
      height: narrow ? 420 : null,
      child: BentoTile(
        padding: EdgeInsets.zero,
        clip: true,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'images/profile.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.03, 0),
              semanticLabel: 'Portrait of Arun Prakash',
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xE6000000)],
                  stops: [0.5, 1],
                ),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Profile.name, style: AppType.display(size: 22, height: 1.1)),
                  const SizedBox(height: 4),
                  Text(
                    'Data Engineer II  ·  Based in Kerala',
                    style: AppType.sans(size: 13, color: AppColors.body, height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearsTile extends StatelessWidget {
  const _YearsTile();

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TileLabel('Experience'),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('3+', style: AppType.display(size: 64, color: AppColors.accent, height: 0.9)),
              const SizedBox(height: 8),
              Text(
                'years on enterprise data platforms at Amdocs',
                style: AppType.sans(size: 14, color: AppColors.body, height: 1.35),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CertTile extends StatelessWidget {
  const _CertTile();

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      padding: const EdgeInsets.fromLTRB(12, 16, 20, 16),
      onTap: () => openExternal(context, Profile.databricksCredential),
      hoverBorder: const Color(0xFFFF3621),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0x1FFF3621), Color(0x00131316)],
        stops: [0, 0.7],
      ),
      child: Row(
        children: [
          Image.asset(
            'images/databricks_de_professional.png',
            width: 116,
            height: 116,
            filterQuality: FilterQuality.medium,
            semanticLabel: 'Databricks Certified Data Engineer Professional badge',
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const TileLabel('Certified'),
                const SizedBox(height: 10),
                Text(
                  'Databricks Data Engineer Professional',
                  style: AppType.display(size: 19, height: 1.15),
                ),
                const SizedBox(height: 10),
                Text(
                  'Verify credential ↗',
                  style: AppType.sans(size: 12.5, color: AppColors.muted, height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplitsyTeaser extends StatelessWidget {
  const _SplitsyTeaser({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      onTap: onTap,
      tint: AppColors.splitsy,
      borderColor: const Color(0xFF1E5A35),
      hoverBorder: AppColors.splitsy,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF14713A), AppColors.splitsyDeep],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('images/splitsy_icon.png', width: 36, height: 36),
              ),
              const Spacer(),
              const Icon(Icons.arrow_downward_rounded, size: 18, color: Color(0xCCFFFFFF)),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Splitsy', style: AppType.display(size: 30)),
              const SizedBox(height: 6),
              Text(
                'My expense-splitting app, live on Google Play',
                style: AppType.sans(size: 13.5, color: const Color(0xDDFFFFFF), height: 1.35),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile();

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TileLabel('Open to'),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final city in ['Pune', 'Hyderabad', 'Bengaluru', 'Chennai'])
                Text(city, style: AppType.display(size: 20, height: 1.3)),
              const SizedBox(height: 8),
              Text(
                'Based in Kerala',
                style: AppType.sans(size: 13, color: AppColors.muted, height: 1.3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
