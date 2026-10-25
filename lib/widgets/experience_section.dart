import 'package:flutter/material.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          index: '02  —  EXPERIENCE',
          title: 'Three years on the platform',
          lede:
              'One company so far. I joined in September 2023 and work on its enterprise data platform as a Data Engineer II.',
        ),
        const SizedBox(height: 32),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.raised,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.line),
          ),
          child: Padding(
            padding: EdgeInsets.all(wide ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: _RoleTitle()),
                      const SizedBox(width: 24),
                      Text(
                        'SEP 2023  —  PRESENT',
                        style: AppType.mono(size: 12, color: AppColors.copper),
                      ),
                    ],
                  )
                else ...[
                  Text(
                    'SEP 2023  —  PRESENT',
                    style: AppType.mono(size: 12, color: AppColors.copper),
                  ),
                  const SizedBox(height: 12),
                  const _RoleTitle(),
                ],
                const SizedBox(height: 22),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Tag('Pune'),
                    Tag('Technology'),
                  ],
                ),
                const SizedBox(height: 28),
                const Divider(height: 1, color: AppColors.line),
                const SizedBox(height: 8),
                for (final line in Profile.focus) _FocusLine(line),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleTitle extends StatelessWidget {
  const _RoleTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Engineer II',
          style: AppType.serif(size: 34, height: 1, letterSpacing: -0.8),
        ),
        const SizedBox(height: 6),
        Text(
          'Amdocs',
          style: AppType.sans(size: 16, color: AppColors.muted, height: 1.2),
        ),
      ],
    );
  }
}

class _FocusLine extends StatelessWidget {
  const _FocusLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.copper,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(text, style: AppType.sans(size: 16, color: AppColors.body)),
          ),
        ],
      ),
    );
  }
}
