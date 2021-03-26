import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketeasy/components/cards.dart';
import 'package:marketeasy/models/produto.dart';
import '../main.dart';
import '../models/dados.dart';
import '../services/api.dart';
import 'package:intl/intl.dart';

class Lista extends StatefulWidget {
  @override
  ListaState createState() => ListaState();
}

class ListaState extends State<Lista> {

  bool _carregarLista = false;
  double _opacity = 0.0;
  var _dados = Dados();
  var _horaAtual;
  var _timer;
  DateTime _dataExpiracaoToTime;

  @override
  void initState() {
    _animationMessage();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _horaAtual = DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());
      if (_horaAtual.compareTo(_dados.expiracao) == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login())
        );
      }
    });
    _dataExpiracaoToTime = DateFormat("dd/MM/yyyy HH:mm:ss").parse(_dados.expiracao);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _animationMessage() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(), 
      body: Container(
        color: Color.fromRGBO(232, 232, 232, 1),
        child: _buildContainer(),
      ),
      floatingActionButton: _carregarLista ? FloatActionClearList() : FloatActionUploadList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text("Lista de Produtos"),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        Center(
          child: Text(
            "Fim da seção: " +
            "${_dataExpiracaoToTime.hour.toString().padLeft(2, '0')}:" +
            "${_dataExpiracaoToTime.minute.toString().padLeft(2, '0')}:" +
            "${_dataExpiracaoToTime.second.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.logout),
          onPressed: () async {
            if (await logout()) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Erro ao sair!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: "Fechar",
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ));
            }
          },
          tooltip: "Sair",
        ),
      ],
    );
  }

  Widget _buildText() {
    return Text(
      "Pressione o botão abaixo para carregar a lista de produtos!",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25.0,
        color: Colors.black
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContainer() {
    if (_carregarLista) {
      return FutureBuilder<List<Produto>>(
        future: getProdutos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: EdgeInsets.all(20.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 20.0,
                childAspectRatio: 1.5
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return CardProduto(produto: snapshot.data[index]);
              },
            );
          } if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar a lista!",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }
        },
      );
    } else {
      return AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 800),
        child: Center(
          child: _buildText(),
        ),
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget FloatActionUploadList() {
    return FloatingActionButton.extended(
      onPressed: () {
        if (!_carregarLista) {
          setState(() {
            _carregarLista = true;
          });
        }
      },
      tooltip: "Carregar Lista",
      label: Text("Carregar Lista"),
      icon: Icon(Icons.refresh),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  // ignore: non_constant_identifier_names
  Widget FloatActionClearList() {
    return FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _carregarLista = false;
            _opacity = 0.0;
            _animationMessage();
          });
        },
        tooltip: "Limpar Lista",
        label: Text("Limpar Lista"),
        icon: Icon(Icons.close),
        backgroundColor: Theme.of(context).primaryColor,
    );
  }
}