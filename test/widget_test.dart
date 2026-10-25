import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('portfolio introduces Arun as a data engineer', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Arun Prakash'), findsWidgets);
    expect(find.textContaining('built to be trusted.'), findsOneWidget);
    expect(find.textContaining('Data Engineer II at Amdocs'), findsOneWidget);
    expect(find.text('What I build at Amdocs'), findsOneWidget);
    expect(find.text('Data Engineer Professional'), findsOneWidget);
  });
}
