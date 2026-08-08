import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aida/screens/onboarding_screen.dart';

void main() {
  testWidgets('shows onboarding content and continue button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(onContinue: () {}),
      ),
    );

    expect(find.text('Meet AIDA'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
