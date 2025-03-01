// test/companyDetails/view/company_detail_layout_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:comapany_details/companyDetails/view/company_detail_layout.dart';
import 'package:provider/provider.dart';
import 'package:comapany_details/companyDetails/provider/company_detail_provider.dart';
import 'package:comapany_details/companyDetails/model/company_detail_model.dart';

void main() {
  testWidgets('CompanyDetailLayout displays company details', (
    WidgetTester tester,
  ) async {
    // Create a mock CompanyDetailsProvider
    final companyDetailsProvider = CompanyDetailsProvider();
    companyDetailsProvider.companyDetails = CompanyDetails(
      logo: "https://example.com/logo.png",
      companyName: "Example Company",
      description: "A great company",
      isin: "US1234567890",
      status: "ACTIVE",
      prosAndCons: {
        'pros': ["Good benefits", "Great culture"],
        'cons': ["Long hours"],
      },
      financials: {
        'ebitda': [
          {"value": 1000000},
        ],
        'revenue': [
          {"value": 2000000},
        ],
      },
      issuerDetails: {
        'issuerName': "Example Issuer",
        'typeOfIssuer': "Corporate",
        'sector': "Technology",
        'industry': "Software",
        'issuerNature': "Public",
        'cin': "U12345MH2021PTC123456",
        'leadManager': "Example Lead Manager",
        'registrar': "Example Registrar",
        'debentureTrustee': "Example Trustee",
      },
    );

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<CompanyDetailsProvider>.value(
          value: companyDetailsProvider,
          child: CompanyDetailLayout(),
        ),
      ),
    );

    // Verify that the company details are displayed
    expect(find.text('Example Company'), findsOneWidget);
    expect(find.text('A great company'), findsOneWidget);
  });
}
