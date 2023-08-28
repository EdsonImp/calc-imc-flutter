import '../model/imc_model.dart';

class ImcRepositories{
  final List<ImcModel> _imcs = [];

  Future<List<ImcModel>> listarImcs() async {
    await Future.delayed(const Duration(seconds: 2));
    return _imcs;
  }

  Future<void> removeImc(String id) async{
    await Future.delayed(const Duration(seconds: 1));
    _imcs.remove(_imcs.where((imc) => imc.id == id).first);

  }

    void addImc(ImcModel imcModel){
      _imcs.add(imcModel);
    }

}