class UserModel {
  final String email;
  final String apiKey;
  final String at; // Auth token
  final String region;
  final String imei;

  UserModel({
    required this.email,
    required this.apiKey,
    required this.at,
    required this.region,
    required this.imei,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String region, String imei) {
    return UserModel(
      email: json['user']['email'],
      apiKey: json['user']['apikey'],
      at: json['at'],
      region: region,
      imei: imei,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'apiKey': apiKey,
      'at': at,
      'region': region,
      'imei': imei,
    };
  }
}
