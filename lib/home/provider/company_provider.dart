import 'package:comapany_details/home/model/company_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyProvider with ChangeNotifier {
  List<Company> _companies = [];
  bool _isLoading = false;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;

  Future<void> fetchCompanies() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(
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
