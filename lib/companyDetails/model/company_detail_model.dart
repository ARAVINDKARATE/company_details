class CompanyDetails {
  final String logo;
  final String companyName;
  final String description;
  final String isin;
  final String status;
  final Map<String, List<String>> prosAndCons;
  final Map<String, dynamic> financials;
  final Map<String, String> issuerDetails;

  CompanyDetails({
    required this.logo,
    required this.companyName,
    required this.description,
    required this.isin,
    required this.status,
    required this.prosAndCons,
    required this.financials,
    required this.issuerDetails,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      logo: json['logo'],
      companyName: json['company_name'],
      description: json['description'],
      isin: json['isin'],
      status: json['status'],
      prosAndCons: {
        'pros': List<String>.from(json['pros_and_cons']['pros']),
        'cons': List<String>.from(json['pros_and_cons']['cons']),
      },
      financials: json['financials'],
      issuerDetails: {
        'issuerName': json['issuer_details']['issuer_name'],
        'typeOfIssuer': json['issuer_details']['type_of_issuer'],
        'sector': json['issuer_details']['sector'],
        'industry': json['issuer_details']['industry'],
        'issuerNature': json['issuer_details']['issuer_nature'],
        'cin': json['issuer_details']['cin'],
        'leadManager': json['issuer_details']['lead_manager'],
        'registrar': json['issuer_details']['registrar'],
        'debentureTrustee': json['issuer_details']['debenture_trustee'],
      },
    );
  }
}
