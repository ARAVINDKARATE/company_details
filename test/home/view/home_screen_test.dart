import 'package:comapany_details/home/model/company_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:comapany_details/home/view/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:comapany_details/home/provider/company_provider.dart';

void main() {
  testWidgets(
    'HomeScreen displays loading indicator when companies are loading',
    (WidgetTester tester) async {
      // Create a mock CompanyProvider
      final companyProvider = CompanyProvider();
      companyProvider.isLoading = true;

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CompanyProvider>.value(
            value: companyProvider,
            child: HomeScreen(),
          ),
        ),
      );

      // Verify that the loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('HomeScreen displays company list when companies are loaded', (
    WidgetTester tester,
  ) async {
    // Create a mock CompanyProvider with some dummy data
    final companyProvider = CompanyProvider();
    companyProvider.companies = [
      Company(
        logo: "https://example.com/logo.png",
        isin: "US1234567890",
        rating: "AAA",
        companyName: "Example Company",
        tags: ["Tech", "Finance"],
      ),
    ];
    companyProvider.isLoading = false;

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<CompanyProvider>.value(
          value: companyProvider,
          child: HomeScreen(),
        ),
      ),
    );

    // Verify that the company list is displayed
    expect(find.text('Example Company'), findsOneWidget);
  });
}
