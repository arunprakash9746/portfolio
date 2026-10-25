import 'package:flutter/material.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 860;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          index: '03  —  SKILLS',
          title: 'The toolbox I actually use',
        ),
        const SizedBox(height: 32),
        for (var i = 0; i < Profile.skillGroups.length; i++) ...[
          if (i > 0) const SizedBox(height: 22),
          _SkillGroup(group: Profile.skillGroups[i]),
        ],
        const SizedBox(height: 28),
        if (wide)
          const IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _EducationCard()),
                SizedBox(width: 16),
                Expanded(child: _CertCard()),
              ],
            ),
          )
        else
          const Column(
            children: [
              _EducationCard(),
              SizedBox(height: 16),
              _CertCard(),
            ],
          ),
      ],
    );
  }
}

class _SkillGroup extends StatelessWidget {
  const _SkillGroup({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final chips = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final item in group.items) Tag(item)],
    );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.title.toUpperCase(), style: AppType.mono(size: 11, color: AppColors.faint)),
          const SizedBox(height: 10),
          chips,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              group.title.toUpperCase(),
              style: AppType.mono(size: 11, color: AppColors.faint),
            ),
          ),
        ),
        Expanded(child: chips),
      ],
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard();

  @override
  Widget build(BuildContext context) {
    return const _CredentialCard(
      kicker: 'EDUCATION',
      title: 'B.Tech, Electronics and Telecommunication',
      detail: 'Vellore Institute of Technology',
      meta: '2023',
    );
  }
}

class _CertCard extends StatefulWidget {
  const _CertCard();

  @override
  State<_CertCard> createState() => _CertCardState();
}

class _CertCardState extends State<_CertCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('CERTIFICATION', style: AppType.mono(size: 11, color: AppColors.copper)),
        const SizedBox(height: 14),
        Text(
          'Data Engineer Professional',
          style: AppType.serif(size: 26, height: 1.1, letterSpacing: -0.5),
        ),
        const SizedBox(height: 10),
        Text(
          'Databricks Certified',
          style: AppType.sans(size: 14, color: AppColors.body, height: 1.3),
        ),
        const SizedBox(height: 4),
        Text(
          'Previously Data Engineer Associate, 2026',
          style: AppType.sans(size: 13, color: AppColors.muted, height: 1.3),
        ),
        const SizedBox(height: 14),
        Text(
          'Verify credential  ↗',
          style: AppType.mono(
            size: 11,
            color: _hover ? AppColors.copper : AppColors.faint,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );

    return PointerTarget(
      onHover: (value) => setState(() => _hover = value),
      child: GestureDetector(
        onTap: () => openExternal(context, Profile.databricksCredential),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _hover ? AppColors.copper : AppColors.line),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x1AFF3621), Color(0x000C0B09)],
              stops: [0, 0.6],
            ),
          ),
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Image.asset(
                'images/databricks_de_professional.png',
                width: 140,
                height: 140,
                filterQuality: FilterQuality.medium,
                semanticLabel: 'Databricks Certified Data Engineer Professional badge',
              ),
              const SizedBox(width: 10),
              Expanded(child: details),
            ],
          ),
        ),
      ),
    );
  }
}

class _CredentialCard extends StatelessWidget {
  const _CredentialCard({
    required this.kicker,
    required this.title,
    required this.detail,
    required this.meta,
  });

  final String kicker;
  final String title;
  final String detail;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kicker, style: AppType.mono(size: 11, color: AppColors.copper)),
            const SizedBox(height: 14),
            Text(
              title,
              style: AppType.serif(size: 26, height: 1.1, letterSpacing: -0.5),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(detail, style: AppType.sans(size: 14, color: AppColors.muted, height: 1.3)),
                ),
                const SizedBox(width: 12),
                Text(meta, style: AppType.mono(size: 12, color: AppColors.ink, letterSpacing: 0.6)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
