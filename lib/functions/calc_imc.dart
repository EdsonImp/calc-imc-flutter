import 'package:flutter/material.dart';

class CalcImc {
  static double calcImc(double peso, double altura) {
    return peso! / (altura! * altura);
  }
}