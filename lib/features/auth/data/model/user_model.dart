import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.token,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    super.countryCode,
    super.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"].toString(),
      email: json["email"] ?? '',
      token: json["token"] ?? '',
      firstName: json["first_name"] ?? '',
      lastName: json["last_name"] ?? '',
      phoneNumber: json["phone_number"] ?? '',
      countryCode: json["country_code"] ?? '',
      isVerified: json["is_verified"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "token": token,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "country_code": countryCode,
      "is_verified": isVerified,
    };
  }
}
