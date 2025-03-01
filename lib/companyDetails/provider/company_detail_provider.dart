import 'package:comapany_details/companyDetails/model/company_detail_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyDetailsProvider with ChangeNotifier {
  CompanyDetails? _companyDetails;

  CompanyDetails? get companyDetails => _companyDetails;

  Future<void> fetchCompanyDetails() async {
    final response = await http.get(
      Uri.parse('https://eo61q3zd4heiwke.m.pipedream.net/'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _companyDetails = CompanyDetails.fromJson(data);
      notifyListeners();
    } else {
      throw Exception('Failed to load company details');
    }
  }
}
