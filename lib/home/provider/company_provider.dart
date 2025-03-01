import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:comapany_details/home/model/company_model.dart';

class CompanyProvider with ChangeNotifier {
  List<Company> _companies = [];
  bool _isLoading = false;
  http.Client? _client;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;

  set client(http.Client? client) {
    _client = client;
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Add a setter for companies
  set companies(List<Company> value) {
    _companies = value;
    notifyListeners();
  }

  Future<void> fetchCompanies() async {
    _isLoading = true;
    notifyListeners();

    final client = _client ?? http.Client();
    final response = await client.get(
      Uri.parse('https://eol122duf9sy4de.m.pipedream.net/'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _companies =
          (data['data'] as List)
              .map((company) => Company.fromJson(company))
              .toList();
    } else {
      throw Exception('Failed to load companies');
    }

    _isLoading = false;
    notifyListeners();
  }
}
