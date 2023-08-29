
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


  String? resultado (double imc){
     if(imc < 16){
       return "Magreza grave";
     }else if(imc < 17){
       return "Magreza moderada";
     }else if(imc < 18.5){
       return "Magreza moderada";
     }else if (imc < 25){
       return "Saudável";
     }else if (imc < 30){
       return "Sobrepeso";
     }else if (imc < 35){
       return "Obesidade grau 1";
     }else if (imc >= 40){
       return "Obesidade grau 2";
     }else {
       return "Obesidade móbida";}


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
                                     content: Text(resultado(imc)!),
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
                                  content: Text(resultado(imc)!),
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
            var imc = CalcImc.calcImc(listaImc[index].peso , listaImc[index].altura);
            var imc_situacao = resultado(imc);
        return Dismissible(
        key: Key(listaImc[index].id),
        background: Container(color:Colors.red),
        onDismissed: (DismissDirection dismissDirection) async{
        await  imcRepositories.removeImc(listaImc[index].id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${listaImc[index].nome} removido")));
        obterListaImc();
         },
        child: Card(
          child: ListTile(
            tileColor: Colors.white54,

            title: Text("Nome: ${listaImc[index].nome} -- Situação : $imc_situacao"),
            subtitle: Text("Peso ${listaImc[index].peso} -"
                " Altura: ${listaImc[index].altura } - IMC = ${imc.round()}"),
          ),
        ),
          );
      }),
    );
  }
}
