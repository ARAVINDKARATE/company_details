import 'package:comapany_details/companyDetails/provider/company_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comapany_details/home/provider/company_provider.dart';

class SearchSuggestionWidget extends StatefulWidget {
  final String searchHint;

  const SearchSuggestionWidget({
    super.key,
    this.searchHint = 'Search by Issuer Name or ISIN',
  });

  @override
  SearchSuggestionWidgetState createState() => SearchSuggestionWidgetState();
}

class SearchSuggestionWidgetState extends State<SearchSuggestionWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);

    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E7EB), width: 0.5),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Image.asset('assets/search.png'),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        hintStyle: TextStyle(
                          color: Color(0xFF99A1AF),
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          // Suggested Results Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'SUGGESTED RESULTS',
              style: TextStyle(
                color: Color(0xFF99A1AF),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                fontFamily: 'Inter',
              ),
            ),
          ),

          if (companyProvider.isLoading)
            Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.white,
                  child: ListView(
                    children:
                        companyProvider.companies.map((company) {
                          return _buildResultTile(
                            company.isin,
                            company.companyName,
                            company.rating,
                            company.logo,
                            _searchController.text,
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultTile(
    String isin,
    String company,
    String rating,
    String avatarImage,
    String searchQuery,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Image.network(avatarImage),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHighlightedText(isin, searchQuery, true),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      rating,
                      style: TextStyle(
                        color: Color(0xFF99A1AF),
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      ' · ',
                      style: TextStyle(
                        color: Color(0xFF99A1AF),
                        fontSize: 20,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Flexible(
                      child: _buildHighlightedText(company, searchQuery, false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              await Provider.of<CompanyDetailsProvider>(
                context,
                listen: false,
              ).fetchCompanyDetails();

              Navigator.pushNamed(context, '/companyDetail');
            },
            child: Image.asset('assets/nextArrow.png', width: 12, height: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, bool isTitle) {
    final TextStyle baseStyle = TextStyle(
      color: isTitle ? Color(0xFF1E2939) : Color(0xFF99A1AF),
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Inter',
    );

    if (query.isEmpty) {
      return isTitle
          ? _buildTextWithBoldLast4Chars(text, isTitle)
          : Text(text, style: baseStyle);
    }

    final textSpans = <InlineSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;
    int indexOfMatch;

    while ((indexOfMatch = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (indexOfMatch > start) {
        textSpans.add(
          TextSpan(text: text.substring(start, indexOfMatch), style: baseStyle),
        );
      }

      textSpans.add(
        TextSpan(
          text: text.substring(indexOfMatch, indexOfMatch + query.length),
          style: baseStyle.copyWith(backgroundColor: Color(0x29D97706)),
        ),
      );

      start = indexOfMatch + query.length;
    }

    if (start < text.length) {
      textSpans.add(TextSpan(text: text.substring(start), style: baseStyle));
    }

    return RichText(text: TextSpan(children: textSpans));
  }

  Widget _buildTextWithBoldLast4Chars(String text, bool isTitle) {
    if (text.length <= 4) {
      return Text(
        text,
        style: TextStyle(
          color: isTitle ? Color(0xFF1E2939) : Color(0xFF99A1AF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      );
    }

    final normalPart = text.substring(0, text.length - 4);
    final boldPart = text.substring(text.length - 4);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: normalPart,
            style: TextStyle(
              color: Color(0xFF99A1AF),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          TextSpan(
            text: boldPart,
            style: TextStyle(
              color: isTitle ? Color(0xFF1E2939) : Color(0xFF99A1AF),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
