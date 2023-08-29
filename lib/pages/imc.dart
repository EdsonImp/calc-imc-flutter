
import 'package:calculadora_imc/model/imc_model.dart';
import 'package:calculadora_imc/repositories/imc_repositories.dart';
import 'package:flutter/material.dart';

import '../functions/calc_imc.dart';
import '../widgets/custon_text_form_field.dart';

class Imc extends StatefulWidget {
  const Imc({super.key});

  @override
  State<Imc> createState() => _ImcState();
}

class _ImcState extends State<Imc> {
  var imcRepositories = ImcRepositories();

  var listaImc = <ImcModel>[];

  @override
  void initState() {

    super.initState();
    obterListaImc();
  }
  void obterListaImc() async{
        listaImc = await imcRepositories.listarImcs();
  }


  Text? resultado (double imc){
     if(imc < 16){
       return Text("Magreza grave");
     }else if(imc < 17){
       return Text("Magreza moderada");
     }else if(imc < 18.5){
       return Text("Magreza moderada");
     }else if (imc < 25){
       return Text("Saudável");
     }else if (imc < 30){
       return Text("Sobrepeso");
     }else if (imc < 35){
       return Text("Obesidade grau 1");
     }else if (imc >= 40){
       return Text("Obesidade grau 2");
     }else {
       return Text("Obesidade móbida");}


  }


  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(context: context, builder: (BuildContext bc){
            return Wrap(
              children: [
                 InkWell(
                  onTap: (){
                   showDialog(context: context, builder: (BuildContext bc){
                     return AlertDialog(
                       title: Text("Insira os dados"),
                       content: Wrap(
                         spacing: 10.0,
                         children: [
                           CustonTextFormField(controller: pesoController, hintText: "Digite o peso"),
                           const SizedBox(height: 10.0),
                           CustonTextFormField(controller: alturaController, hintText: "Digite a altura"),
                           const SizedBox(height: 10.0),
                           TextFormField(
                             keyboardType: TextInputType.text,
                             controller: nomeController,
                             textAlign: TextAlign.center,
                             decoration:  InputDecoration(
                               border: const OutlineInputBorder(
                                   borderSide: BorderSide.none,
                                   borderRadius: BorderRadius.all(
                                       Radius.circular(20))),
                               filled: true,
                               fillColor: Theme.of(context).colorScheme.primary,
                               hintText: 'Digite seu nome',
                               hintStyle: const TextStyle(color: Colors.white),
                             ),),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               ElevatedButton(onPressed: (){
                                 double peso = double.parse(pesoController.text);
                                 double altura = double.parse(alturaController.text);
                                 ImcModel imcModel = ImcModel(nomeController.text, peso, altura);
                                 var imc = CalcImc.calcImc(peso, altura);
                                 showDialog(context: context, builder: (BuildContext bc){
                                   return AlertDialog(
                                     title: Text("Seu IMC: ${imc.round()}"),
                                     content: resultado(imc),
                                     actions: [
                                       ElevatedButton(onPressed: (){
                                         Navigator.pop(context);
                                       }, child: Text("Sair")),
                                       ElevatedButton(onPressed: (){
                                         imcRepositories.addImc(imcModel);
                                         Navigator.pop(context);
                                         setState(() {

                                         });
                                       }, child: Text("Gravar")),

                                     ],
                                   );
                                 }
                                 );
                                 }, child: Text("Calcular")),
                               ElevatedButton(onPressed: (){
                                 Navigator.pop(context);
                               }, child: Text("Sair")),
                             ],
                           ),
                         ],
                       ),
                     );
                   }
                   );
                  },
                  child: const ListTile(
                    title: Text("Add imc atual em lista"),
                    leading: Icon(Icons.list_alt),
                  ),
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
                              CustonTextFormField(controller: pesoController, hintText: "Digite o peso"),
                              const SizedBox(height: 10.0),
                              CustonTextFormField(controller: alturaController, hintText: "Digite a altura"),
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

                              showDialog(context: context, builder: (BuildContext bc){
                                return AlertDialog(
                                  title: Text("Seu IMC: ${imc.round()}"),
                                  content: resultado(imc),
                                  actions: [
                                    ElevatedButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text("Sair"))
                                  ],
                                );
                              }
                              );

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
      body: ListView.builder(
          itemCount: listaImc.length,
          itemBuilder: (BuildContext bc, int index){
        return Container(
          child: ListTile(
            title: Text("Nome: ${listaImc[index].nome}"),
            subtitle: Text("Peso ${listaImc[index].peso} -"
                " Altura: ${listaImc[index].altura } - "
                " = ${listaImc[index].peso.round() / (listaImc[index].altura.round() * listaImc[index].altura.round() )}"),
          )
        );
      }),
    );
  }
}
