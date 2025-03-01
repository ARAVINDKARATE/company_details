import 'package:comapany_details/companyDetails/view/widgets/ProsConsComponent.dart';
import 'package:flutter/material.dart';
import 'widgets/company_info_component.dart';
import 'widgets/tabs_component.dart';
import 'widgets/financials_issuer_details_component.dart';

class CompanyDetailLayout extends StatefulWidget {
  const CompanyDetailLayout({super.key});

  @override
  _CompanyDetailLayoutState createState() => _CompanyDetailLayoutState();
}

class _CompanyDetailLayoutState extends State<CompanyDetailLayout> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/back_button.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 24)),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompanyInfoComponent(),
                    TabsComponent(
                      initialIndex: selectedTabIndex,
                      onTabChanged: (index) {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                    ),
                    selectedTabIndex == 0
                        ? FinancialsIssuerDetailsComponent()
                        : ProsConsComponent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
