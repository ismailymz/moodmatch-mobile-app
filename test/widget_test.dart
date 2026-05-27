import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:moodmatch_mobile_app/constants/app_constants.dart';
import 'package:moodmatch_mobile_app/main.dart';

void main() {
  testWidgets('shows MoodMatch home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('Welcome to MoodMatch'), findsOneWidget);
  });
}
