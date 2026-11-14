import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/mouse_region.dart';
import 'package:my_portfolio/widgets/portfolio_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Text measured before a web font arrives keeps stale intrinsic heights,
  // which breaks the equal-height bento rows, so load fonts before first frame.
  try {
    await GoogleFonts.pendingFonts([
      AppType.display(),
      AppType.sans(),
      AppType.sans(weight: FontWeight.w500),
      AppType.sans(weight: FontWeight.w600),
      AppType.mono(),
    ]).timeout(const Duration(seconds: 4));
  } catch (_) {
    // Render with fallback fonts rather than not at all.
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arun Prakash · Data Engineer II',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: kIsWeb ? const Mouse() : const PortfolioPage(),
    );
  }
}
