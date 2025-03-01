class Company {
  final String logo;
  final String isin;
  final String rating;
  final String companyName;
  final List<String> tags;

  Company({
    required this.logo,
    required this.isin,
    required this.rating,
    required this.companyName,
    required this.tags,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      logo: json['logo'],
      isin: json['isin'],
      rating: json['rating'],
      companyName: json['company_name'],
      tags: List<String>.from(json['tags']),
    );
  }
}
