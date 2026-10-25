import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/data/profile.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/chrome.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          index: '05  —  CONTACT',
          title: 'Tell me about the platform.',
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            'I am based in Kerala and open to data engineering roles in Pune, Hyderabad, Bengaluru, and Chennai. English and Malayalam.',
            style: AppType.sans(size: 17, color: AppColors.body),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(
              label: 'Email ${Profile.email}',
              filled: true,
              onPressed: () => openExternal(context, Profile.mailUri),
            ),
            AppButton(
              label: Profile.phoneDisplay,
              onPressed: () => openExternal(context, Profile.phoneUri),
            ),
          ],
        ),
        const SizedBox(height: 36),
        const Divider(height: 1, color: AppColors.line),
        const SizedBox(height: 22),
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '© 2026 ${Profile.name}',
                  style: AppType.mono(size: 11, color: AppColors.faint, letterSpacing: 0.4),
                ),
              ),
              const _SocialRow(),
            ],
          )
        else ...[
          const _SocialRow(),
          const SizedBox(height: 16),
          Text(
            '© 2026 ${Profile.name}',
            style: AppType.mono(size: 11, color: AppColors.faint, letterSpacing: 0.4),
          ),
        ],
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  static const _icons = <String, IconData>{
    'GitHub': FontAwesomeIcons.github,
    'Instagram': FontAwesomeIcons.instagram,
    'Facebook': FontAwesomeIcons.facebookF,
    'X': FontAwesomeIcons.xTwitter,
    'YouTube': FontAwesomeIcons.youtube,
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
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
    );
  }
}
