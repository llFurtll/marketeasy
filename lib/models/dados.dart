class Dados {
  static Dados _instance;

  factory Dados({String token, String expiracao}) {
    _instance ??= Dados._internalConstructor(token, expiracao);
    return _instance;
  }

  Dados._internalConstructor(this.token, this.expiracao);

  String token;
  String expiracao;
}