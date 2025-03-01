import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:comapany_details/home/provider/company_provider.dart';

@GenerateMocks([http.Client])
void main() {
  group('CompanyProvider', () {
    late CompanyProvider companyProvider;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        return http.Response('''{
          "data": [
            {
              "logo": "https://example.com/logo.png",
              "isin": "US1234567890",
              "rating": "AAA",
              "company_name": "Example Company",
              "tags": ["Tech", "Finance"]
            }
          ]
        }''', 200);
      });
      companyProvider = CompanyProvider();
    });

    test(
      'fetchCompanies returns a list of companies if the http call completes successfully',
      () async {
        // Mock the HTTP request
        when(
          mockClient.get(Uri.parse('https://eol122duf9sy4de.m.pipedream.net/')),
        ).thenAnswer(
          (_) async => http.Response('''
          {
            "data": [
              {
                "logo": "https://example.com/logo.png",
                "isin": "US1234567890",
                "rating": "AAA",
                "company_name": "Example Company",
                "tags": ["Tech", "Finance"]
              }
            ]
          }
          ''', 200),
        );

        // Inject the mock client into the provider
        companyProvider.client = mockClient;

        // Call the method to test
        await companyProvider.fetchCompanies();

        // Verify the results
        expect(companyProvider.companies.length, 1);
        expect(companyProvider.companies[0].companyName, "Example Company");
      },
    );

    test(
      'fetchCompanies throws an exception if the http call completes with an error',
      () async {
        // Mock the HTTP request to return an error
        when(
          mockClient.get(Uri.parse('https://eol122duf9sy4de.m.pipedream.net/')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        // Inject the mock client into the provider
        companyProvider.client = mockClient;

        // Verify that an exception is thrown
        expect(
          () async => await companyProvider.fetchCompanies(),
          throwsException,
        );
      },
    );
  });
}
