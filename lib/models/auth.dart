class Authentication {
  String status;
  String token;
  String expiracao;

  Authentication({ this.status, this.token, this.expiracao });

  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(
      status: json['response']['status'],
      token: json['response']['token'],
      expiracao: json['response']['tokenExpiration'],
    );
  }
}