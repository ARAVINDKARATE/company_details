import 'package:comapany_details/companyDetails/provider/company_detail_provider.dart';
import 'package:comapany_details/home/provider/company_provider.dart';
import 'package:comapany_details/home/view/home_screen.dart';
import 'package:comapany_details/companyDetails/view/company_detail_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => CompanyDetailsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
      routes: {
        '/companyDetail':
            (context) => CompanyDetailLayout(), // Define the route
      },
    );
  }
}
