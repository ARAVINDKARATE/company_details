import 'package:comapany_details/home/view/widgets/HeaderComponent.dart';
import 'package:comapany_details/home/view/widgets/SearchSuggestionWidget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: Column(
        children: [
          HeaderComponent(),
          Expanded(child: SearchSuggestionWidget()),
        ],
      ),
    );
  }
}
