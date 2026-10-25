import 'package:flutter/material.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 860;
    final cards = [
      for (final item in Profile.work) _WorkCard(item: item),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          index: '01  —  WORK',
          title: 'What I build at Amdocs',
          lede:
              'Enterprise data platforms. The four threads below are the work I spend my weeks on, from the shape of the lakehouse to the cost of a single Spark job.',
        ),
        const SizedBox(height: 36),
        if (wide)
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          )
        else
          Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                cards[i],
              ],
            ],
          ),
      ],
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({required this.item});

  final WorkItem item;

  @override
  Widget build(BuildContext context) {
    return HoverPanel(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.index, style: AppType.mono(color: AppColors.copper, size: 12)),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: AppType.serif(size: 28, height: 1.05, letterSpacing: -0.6),
            ),
            const SizedBox(height: 12),
            Text(item.summary, style: AppType.sans(size: 15, color: AppColors.body)),
            const SizedBox(height: 18),
            Text(
              item.outcome,
              style: AppType.serif(
                size: 18,
                style: FontStyle.italic,
                color: AppColors.ink,
                height: 1.3,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final tag in item.tags) Tag(tag)],
            ),
          ],
        ),
      ),
    );
  }
}

class EarlierWorkSection extends StatelessWidget {
  const EarlierWorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          index: '04  —  EARLIER BUILDS',
          title: 'Flutter, before the platform work',
          lede:
              'Side projects from when I was learning to ship interfaces. They are still on GitHub.',
        ),
        const SizedBox(height: 28),
        for (var i = 0; i < Profile.projects.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: AppColors.line),
          _ProjectRow(project: Profile.projects[i]),
        ],
        const Divider(height: 1, color: AppColors.line),
      ],
    );
  }
}

class _ProjectRow extends StatefulWidget {
  const _ProjectRow({required this.project});

  final SideProject project;

  @override
  State<_ProjectRow> createState() => _ProjectRowState();
}

class _ProjectRowState extends State<_ProjectRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 720;
    final project = widget.project;

    return PointerTarget(
      accent: true,
      onHover: (value) => setState(() => _hover = value),
      child: GestureDetector(
        onTap: () => openExternal(context, project.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          color: _hover ? AppColors.raised : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: AppType.serif(size: 24, letterSpacing: -0.4),
                    ),
                    const SizedBox(height: 6),
                    Text(project.summary, style: AppType.sans(size: 14, color: AppColors.muted)),
                    const SizedBox(height: 8),
                    Text(
                      'View on GitHub',
                      style: AppType.mono(size: 11, color: AppColors.copper, letterSpacing: 0.8),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        project.title,
                        style: AppType.serif(
                          size: 26,
                          letterSpacing: -0.4,
                          color: _hover ? AppColors.copper : AppColors.ink,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        project.summary,
                        style: AppType.sans(size: 15, color: AppColors.muted),
                      ),
                    ),
                    Text(
                      'GitHub',
                      style: AppType.mono(
                        size: 11,
                        color: _hover ? AppColors.copper : AppColors.faint,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
