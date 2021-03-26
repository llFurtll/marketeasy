import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketeasy/models/produto.dart';

// ignore: must_be_immutable
class CardProduto extends StatelessWidget {

  Produto produto;

  CardProduto({this.produto});

  

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text("Código: ${produto.codigo}", style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(produto.descricao, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text("Valor: R\$${produto.preco}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: BarCodeImage(
                params: Code128BarCodeParams(
                  produto.codigo_de_barras,
                  withText: true,
                  altText: produto.descricao,
                  lineWidth: 1.5,
                  barHeight: 50.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}