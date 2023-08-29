
import 'package:flutter/material.dart';

import '../functions/calc_imc.dart';

class Imc extends StatefulWidget {
  const Imc({super.key});

  @override
  State<Imc> createState() => _ImcState();
}

class _ImcState extends State<Imc> {
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(context: context, builder: (BuildContext bc){
            return Wrap(
              children: [
                const ListTile(
                  title: Text("Add imc atual em lista"),
                  leading: Icon(Icons.list_alt),
                ),
                InkWell(
                  onTap: (){
                    showDialog(context: context,
                        builder: (BuildContext bc){
                      return  SingleChildScrollView(
                        child: AlertDialog(
                          title: const Text("Imc Rápido"),
                          content: Column(
                            children: [
                              TextFormField(
                                controller: pesoController,
                                textAlign: TextAlign.center,
                                  decoration:  InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.primary,
                                  hintText: 'Digite o peso',
                                  hintStyle: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                controller: alturaController,
                                textAlign: TextAlign.center,
                                decoration:  InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.primary,
                                  hintText: 'Digite a altura',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),),

                            ],
                          ),
                          actions: [
                            ElevatedButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: const Text("Sair")),
                            ElevatedButton(onPressed: (){
                              var peso = double.parse(pesoController.text);
                              var altura = double.parse(alturaController.text);
                              var imc = CalcImc.calcImc(peso, altura);
                              print(imc);


                              showDialog(context: context, builder: (BuildContext bc){
                                return AlertDialog(
                                  title: Text("Seu imc $imc"),
                                );
                              });

                              }, child: const Text("Calcula")),

                          ],
                        ),
                      );

                    });
                  },
                  child: const ListTile(
                    title: Text("Cálculo rápido"),
                    leading: Icon(Icons.calculate_outlined),
                  ),
                )
              ],
            );
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Calculadora de IMC"),
        centerTitle: true,
      ),
    );
  }
}
