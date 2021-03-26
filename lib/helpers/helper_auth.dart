import 'package:marketeasy/models/dados.dart';

import '../services/api.dart';

Future<bool> validateAuth(String usuario, String password) async {
  var resposta = await getAuthentication(usuario, password);

  if (resposta.status == "ok") {
    var dados = Dados();
    dados.token = resposta.token;
    dados.expiracao = resposta.expiracao;
    return true;
  } else {
    return false;
  }
}