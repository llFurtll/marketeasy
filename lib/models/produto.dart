class Produto {
  int codigo;
  String descricao;
  double preco;
  // ignore: non_constant_identifier_names
  String codigo_de_barras;

  // ignore: non_constant_identifier_names
  Produto({this.codigo, this.descricao, this.preco, this.codigo_de_barras});

  factory Produto.fromJson(Map<dynamic, dynamic> json) {
    return Produto(
      codigo: json["Codigo"],
      descricao: json["Descricao"],
      preco: json["Preco"],
      codigo_de_barras: json["CodigoBarras"],
    );
  }
}