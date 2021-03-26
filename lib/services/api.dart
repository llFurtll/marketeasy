import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketeasy/models/auth.dart';
import 'package:marketeasy/models/dados.dart';
import 'package:marketeasy/models/produto.dart';

Future<dynamic> getAuthentication(String user, String password) async {

  final response = await http.post(
    Uri.http( "servicosflex.rpinfo.com.br:9000", '/v1.1/auth'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'usuario': user,
      'senha': password
    }),
  );

  if (response.statusCode == 200){
    return Authentication.fromJson(jsonDecode(response.body));
  } else {
    return false;
  }
}

Future<List<Produto>> getProdutos() async {

  var dados = Dados();

  final response = await http.get(
    Uri.http("servicosflex.rpinfo.com.br:9000", "/v2.0/produtounidade/listaprodutos/0/unidade/83402711000110"),
    headers: {
      "token": "${dados.token}"
    }
  );

  var lista = List<Produto>.empty(growable: true);

  if (response.statusCode == 200) {
    var respostaJson = jsonDecode(response.body);
    respostaJson["response"]["produtos"].forEach((value) {
      lista.add(Produto.fromJson(value));
    });

    return lista;
  } else {
    return lista;
  }
}

Future<dynamic> logout() async {
  var dados = Dados();

  final response = await http.get(
    Uri.http("servicosflex.rpinfo.com.br:9000", "/v1.1/logout"),
    headers: {
      "token": "${dados.token}"
    }
  );

  if (response.statusCode == 200) {
    var respostaJson = jsonDecode(response.body);

    if (respostaJson["response"]["status"] == "ok") {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}