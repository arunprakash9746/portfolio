import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';

class SkillsBento extends StatelessWidget {
  const SkillsBento({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(label: 'Toolbox', title: 'Skills and credentials'),
        BentoRow(
          flex: [7, 5],
          children: [_SkillsTile(), _CredentialsColumn()],
        ),
      ],
    );
  }
}

class _SkillsTile extends StatelessWidget {
  const _SkillsTile();

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < Profile.skillGroups.length; i++) ...[
            if (i > 0) const SizedBox(height: 26),
            TileLabel(Profile.skillGroups[i].title),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in Profile.skillGroups[i].items)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.tileHi,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Text(
                      s,
                      style: AppType.sans(size: 13.5, color: AppColors.ink, height: 1.2),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CredentialsColumn extends StatelessWidget {
  const _CredentialsColumn();

  @override
  Widget build(BuildContext context) {
    final stacked = breakpointOf(MediaQuery.sizeOf(context).width) == Breakpoint.narrow;
    Widget fill(Widget child) => stacked ? child : Expanded(child: child);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        fill(
          BentoTile(
            onTap: () => openExternal(context, Profile.databricksCredential),
            hoverBorder: const Color(0xFFFF3621),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TileLabel('Certification', color: Color(0xFFFF6A4D)),
                const SizedBox(height: 12),
                Text('Data Engineer Professional', style: AppType.display(size: 22, height: 1.15)),
                const SizedBox(height: 6),
                Text(
                  'Databricks Certified. Previously Data Engineer Associate, 2026.',
                  style: AppType.sans(size: 13.5, color: AppColors.muted, height: 1.4),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: bentoGap),
        fill(
          BentoTile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TileLabel('Education  ·  2023'),
                const SizedBox(height: 12),
                Text(
                  'B.Tech, Electronics and Telecommunication',
                  style: AppType.display(size: 22, height: 1.15),
                ),
                const SizedBox(height: 6),
                Text(
                  'Vellore Institute of Technology',
                  style: AppType.sans(size: 13.5, color: AppColors.muted, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EarlierBento extends StatelessWidget {
  const EarlierBento({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = breakpointOf(MediaQuery.sizeOf(context).width);
    final tiles = [for (final p in Profile.projects) _ProjectTile(p)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(label: 'Before data', title: 'Earlier Flutter builds'),
        if (bp == Breakpoint.wide)
          BentoRow(flex: const [1, 1, 1, 1], children: tiles)
        else ...[
          BentoRow(flex: const [1, 1], children: tiles.sublist(0, 2)),
          const SizedBox(height: bentoGap),
          BentoRow(flex: const [1, 1], children: tiles.sublist(2)),
        ],
      ],
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile(this.project);

  final SideProject project;

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      onTap: () => openExternal(context, project.url),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              FaIcon(FontAwesomeIcons.github, size: 16, color: AppColors.muted),
              Spacer(),
              Icon(Icons.arrow_outward_rounded, size: 16, color: AppColors.faint),
            ],
          ),
          const SizedBox(height: 22),
          Text(project.title, style: AppType.display(size: 18, height: 1.2)),
          const SizedBox(height: 8),
          Text(project.summary, style: AppType.sans(size: 13.5, color: AppColors.muted, height: 1.45)),
        ],
      ),
    );
  }
}

class ContactBento extends StatelessWidget {
  const ContactBento({super.key});

  static const _icons = <String, FaIconData>{
    'GitHub': FontAwesomeIcons.github,
    'Instagram': FontAwesomeIcons.instagram,
    'Facebook': FontAwesomeIcons.facebookF,
    'X': FontAwesomeIcons.xTwitter,
    'YouTube': FontAwesomeIcons.youtube,
  };

  @override
  Widget build(BuildContext context) {
    final bp = breakpointOf(MediaQuery.sizeOf(context).width);
    final narrow = bp == Breakpoint.narrow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BentoTile(
          padding: EdgeInsets.all(narrow ? 28 : 48),
          gradient: const RadialGradient(
            center: Alignment(1, 1.2),
            radius: 1.3,
            colors: [Color(0x33FFB547), Color(0x00131316)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TileLabel('Contact', color: AppColors.accent),
              const SizedBox(height: 16),
              Text(
                'Tell me about the platform.',
                style: AppType.display(size: narrow ? 36 : 56, height: 1.0),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  'Based in Kerala and open to data engineering roles in Pune, Hyderabad, Bengaluru, and Chennai. English and Malayalam.',
                  style: AppType.sans(size: 16),
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  PillButton(
                    label: Profile.email,
                    icon: Icons.mail_outline_rounded,
                    fill: AppColors.accent,
                    foreground: AppColors.accentInk,
                    onPressed: () => openExternal(context, Profile.mailUri),
                  ),
                  PillButton(
                    label: Profile.phoneDisplay,
                    icon: Icons.call_outlined,
                    onPressed: () => openExternal(context, Profile.phoneUri),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            spacing: 16,
            children: [
              Text(
                '© 2026 ${Profile.name}',
                style: AppType.mono(size: 11, color: AppColors.faint, letterSpacing: 0.4),
              ),
              Wrap(
                spacing: 2,
                children: [
                  for (final social in Profile.socials)
                    PointerTarget(
                      child: IconButton(
                        tooltip: social.label,
                        mouseCursor: interactiveCursor,
                        onPressed: () => openExternal(context, social.url),
                        icon: FaIcon(_icons[social.label], size: 16, color: AppColors.muted),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
