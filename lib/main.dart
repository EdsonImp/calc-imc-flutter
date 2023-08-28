import 'package:calculadora_imc/pages/imc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'calculadora de imc',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
      ),
      home: const Imc(),
    );
  }
}
