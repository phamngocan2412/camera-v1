import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String token;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String countryCode;
  final bool isVerified;

  const User({
    required this.id,
    required this.email,
    required this.token,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.countryCode = '',
    this.isVerified = false,
  });

  @override
  List<Object> get props => [
    id,
    email,
    token,
    firstName,
    lastName,
    phoneNumber,
    countryCode,
    isVerified,
  ];
}
