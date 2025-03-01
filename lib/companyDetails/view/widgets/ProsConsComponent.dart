import 'package:comapany_details/companyDetails/provider/company_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProsConsComponent extends StatelessWidget {
  const ProsConsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final companyDetails =
        Provider.of<CompanyDetailsProvider>(context).companyDetails;

    if (companyDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width:
                constraints.maxWidth > 400 ? 350 : constraints.maxWidth * 0.9,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
                  ),
                  child: const Text(
                    'Pros and Cons',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF020617),
                      height: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pros',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF15803D),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...companyDetails.prosAndCons['pros']!.map(
                        (pro) => _buildProItem(pro, 'check.png'),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Cons',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB45309),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...companyDetails.prosAndCons['cons']!.map(
                        (con) => _buildConItem(con),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProItem(String text, String checkIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0x1F16A34A),
              borderRadius: BorderRadius.circular(749.25),
              border: Border.all(color: const Color(0xFF12813D), width: 0.75),
            ),
            child: Image.asset(
              'assets/pros_icon.png',
              width: 9.43,
              height: 9.43,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF364153),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0x1FD97706),
              borderRadius: BorderRadius.circular(749.25),
              border: Border.all(color: const Color(0xFF12813D), width: 0.75),
            ),
            child: Image.asset(
              'assets/cons_icon.png',
              width: 9.43,
              height: 9.43,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
