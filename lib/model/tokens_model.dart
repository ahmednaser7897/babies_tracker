class TokensModel {
  final String id;
  final String token;

  TokensModel({
    required this.id,
    required this.token,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      id: json['id'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'token': token,
    };
  }
}
