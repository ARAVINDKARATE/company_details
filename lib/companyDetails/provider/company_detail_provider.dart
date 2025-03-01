import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:comapany_details/companyDetails/model/company_detail_model.dart';

class CompanyDetailsProvider with ChangeNotifier {
  CompanyDetails? _companyDetails;

  CompanyDetails? get companyDetails => _companyDetails;

  set companyDetails(CompanyDetails? value) {
    _companyDetails = value;
    notifyListeners();
  }

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
