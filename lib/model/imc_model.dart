
import 'package:flutter/material.dart';

class ImcModel{
  String _id = UniqueKey().toString();
  String _nome = "";
  double _peso = 0;
  double _altura = 0;

  ImcModel(this._nome,this._peso, this._altura);

  double get altura => _altura;

  set altura(double value) {
    _altura = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  double get peso => _peso;

  set peso(double value) {
    _peso = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  @override
  String toString() {
    return 'ImcModel{_id: $_id, _nome: $_nome, _peso: $_peso, _altura: $_altura}';
  }
}