import 'package:flutter/material.dart';
import 'package:interview_coding_test/provider/contact_provider.dart';
import 'package:interview_coding_test/view/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContactProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Contacts App',
      home: HomePage(),
    );
  }
}
