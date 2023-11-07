import 'package:barcode_scanner/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'input_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: ChangeNotifierProvider(
                create: (context) => InputModel(),
                child: const HomePage(
                  withAddButton: true,
                ),
              )),
        ),
      ),
    );
  }
}
