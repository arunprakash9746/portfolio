import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/mouse_region.dart';
import 'package:my_portfolio/widgets/portfolio_page.dart';

void main() {
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
