import 'dart:developer';

import 'package:comapany_details/companyDetails/provider/company_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class FinancialsIssuerDetailsComponent extends StatefulWidget {
  const FinancialsIssuerDetailsComponent({super.key});

  @override
  FinancialsIssuerDetailsComponentState createState() =>
      FinancialsIssuerDetailsComponentState();
}

class FinancialsIssuerDetailsComponentState
    extends State<FinancialsIssuerDetailsComponent> {
  bool isEbitda = true;

  // X-axis labels for months
  final List<String> xAxisLabels = [
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ];

  @override
  Widget build(BuildContext context) {
    final companyDetails =
        Provider.of<CompanyDetailsProvider>(context).companyDetails;

    if (companyDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildFinancialsSection(companyDetails.financials),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: EdgeInsets.all(16),
          child: _buildIssuerDetailsSection(companyDetails.issuerDetails),
        ),
      ],
    );
  }

  Widget _buildFinancialsSection(Map<String, dynamic> financials) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E5E4), width: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'COMPANY FINANCIALS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: Colors.grey[600],
                  ),
                ),
                _buildToggle(),
              ],
            ),
          ),
          _buildChart(financials),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 0.4),
      ),
      child: Row(
        children: [
          _buildToggleButton('EBITDA', isEbitda),
          _buildToggleButton('Revenue', !isEbitda),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEbitda = text == 'EBITDA';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: const Color(0xFFE5E5E5),
            width: isSelected ? 0.4 : 0,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.black87 : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(Map<String, dynamic> financials) {
    final ebitdaData = financials['ebitda'] as List<dynamic>;
    final revenueData = financials['revenue'] as List<dynamic>;

    // Debug: Print revenue values
    log('Revenue Data: $revenueData');

    // Determine the maximum value in the dataset
    final data =
        isEbitda
            ? revenueData
            : revenueData; // Use revenue for maxY in both charts
    final maxValue = data
        .map<double>(
          (item) => item['value'] / 1000000.0,
        ) // Convert to lakhs (ensure it's double)
        .reduce((a, b) => a > b ? a : b);

    // Add some padding to the maxY value to ensure bars fit within the chart area
    final maxY = maxValue * 1.2; // Adjust the multiplier as needed

    return Container(
      height: 158,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          BarChart(
            BarChartData(
              gridData: FlGridData(
                show: true,
                horizontalInterval: maxY / 6, // Adjust intervals dynamically
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[400]!,
                    strokeWidth:
                        (value == 0 || value == 3.5)
                            ? 1.0
                            : (value % 1 == 0 ? 0.7 : 0.5),
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color:
                        value == 0.34 ? Colors.grey[400]! : Colors.transparent,
                    strokeWidth: 0.8,
                    dashArray: [5, 5],
                  );
                },
                verticalInterval: 0.085, // Adjust for better visibility
                drawVerticalLine: true,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        xAxisLabels[value.toInt()],
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      );
                    },
                    reservedSize: 22,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == maxY) {
                        return Container(); // Hide "0L" and maxY label
                      }
                      return Text(
                        '\u20B9${value.toInt()}L',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      );
                    },
                    reservedSize: 28,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _buildBarGroups(
                isEbitda ? ebitdaData : revenueData,
                maxY,
              ),
              maxY: maxY, // Set maxY dynamically
            ),
          ),
          // Add "2024" and "2025" labels
          Positioned(
            left: 110, // Adjust this value to position "2024"
            top: 4,
            child: Text(
              '2024',
              style: TextStyle(fontSize: 10, color: Colors.grey[400]),
            ),
          ),
          Positioned(
            left: 140, // Adjust this value to position "2025"
            top: 4,
            child: Text(
              '2025',
              style: TextStyle(fontSize: 10, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<dynamic> data, double maxY) {
    final ebitdaData = data; // EBITDA data
    final revenueData =
        isEbitda
            ? Provider.of<CompanyDetailsProvider>(
                  context,
                  listen: false,
                ).companyDetails!.financials['revenue']
                as List<dynamic>
            : data; // Revenue data (use the same data for revenue chart)

    return List.generate(xAxisLabels.length, (index) {
      final ebitdaValue =
          ebitdaData[index]['value'] /
          1000000.0; // Convert to lakhs (ensure it's double)
      final revenueValue =
          revenueData[index]['value'] /
          1000000.0; // Convert to lakhs (ensure it's double)

      // Debug: Print bar heights
      log('Revenue Bar Height: $revenueValue');

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            rodStackItems:
                isEbitda
                    ? [
                      BarChartRodStackItem(0.0, ebitdaValue, Colors.black),
                      BarChartRodStackItem(
                        ebitdaValue,
                        revenueValue,
                        Colors.grey,
                      ),
                    ]
                    : [
                      BarChartRodStackItem(
                        0.0,
                        revenueValue,
                        Color(0xFF155DFC),
                      ),
                    ],
            fromY: 0.0,
            toY:
                isEbitda
                    ? revenueValue
                    : revenueValue, // Ensure toY is set correctly
            color: Colors.transparent,
            width: 12,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    });
  }

  Widget _buildIssuerDetailsSection(Map<String, String> issuerDetails) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset('assets/AddressBook.png', width: 18, height: 18),
                const SizedBox(width: 8),
                Text(
                  'Issuer Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          _buildIssuerDetail('Issuer Name', issuerDetails['issuerName']!),
          _buildIssuerDetail('Type of Issuer', issuerDetails['typeOfIssuer']!),
          _buildIssuerDetail('Sector', issuerDetails['sector']!),
          _buildIssuerDetail('Industry', issuerDetails['industry']!),
          _buildIssuerDetail('Issuer nature', issuerDetails['issuerNature']!),
          _buildIssuerDetail(
            'Corporate Identity Number (CIN)',
            issuerDetails['cin']!,
          ),
          _buildIssuerDetail(
            'Name of the Lead Manager',
            issuerDetails['leadManager']!,
          ),
          _buildIssuerDetail('Registrar', issuerDetails['registrar']!),
          _buildIssuerDetail(
            'Name of Debenture Trustee',
            issuerDetails['debentureTrustee']!,
          ),
        ],
      ),
    );
  }

  Widget _buildIssuerDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1D4ED8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
