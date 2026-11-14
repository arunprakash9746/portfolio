import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  for (final size in const [Size(1440, 900), Size(820, 1180), Size(390, 844)]) {
    testWidgets('portfolio renders at ${size.width.toInt()} wide', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Arun Prakash'), findsWidgets);
      expect(find.textContaining('enterprises can'), findsOneWidget);
      expect(find.textContaining('Data Engineer II at Amdocs'), findsOneWidget);
      expect(find.text('What I build at Amdocs'), findsOneWidget);
      expect(find.text('Databricks Data Engineer Professional'), findsOneWidget);
      expect(find.text('Splitsy, my app on Google Play'), findsOneWidget);
      expect(find.text('Get it on Google Play'), findsOneWidget);
    });
  }
}
