import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String countryCode,
  );
  Future<void> forgotPassword(String email);
  Future<UserModel> verifyOtp(String email, String otp);
  Future<void> resendOtp(String email);
  Future<void> resetPassword(String email, String otp, String newPassword);
  Future<void> verifyResetOtp(String email, String otp);
  Future<void> changePassword(
    String token,
    String oldPassword,
    String newPassword,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  Future<String> _parseErrorMessage(http.Response response) async {
    try {
      final body = json.decode(response.body);
      if (body is Map && body.containsKey('error')) {
        return body['error'].toString();
      }
    } catch (_) {
      // Fallback if parsing fails
    }
    return 'Server Error: ${response.statusCode}';
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 403) {
      final body = json.decode(response.body);
      if (body is Map &&
          body.containsKey('error') &&
          body['error'] == 'email not verified') {
        throw VerificationPendingException(
          message: 'Email not verified. Please verify your account.',
        );
      }
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    } else if (response.statusCode == 404) {
      throw ServerException(message: "User not found", statusCode: 404);
    } else if (response.statusCode == 401) {
      final body = json.decode(response.body);
      String msg = "Invalid credentials";
      if (body is Map && body.containsKey('error')) {
        msg = body['error'];
      }
      throw ServerException(message: msg, statusCode: 401);
    } else {
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String countryCode,
  ) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'country_code': countryCode,
      }),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 200) {
      // Check if it's the specific "pending verification" message
      final body = json.decode(response.body);
      if (body is Map &&
          body.containsKey('message') &&
          body['message'].toString().contains('đang chờ xác thực')) {
        throw VerificationPendingException(message: body['message']);
      }
      // If it's some other 200 OK (unlikely for register but safe to fallback), try parsing or throw error
      try {
        return UserModel.fromJson(body);
      } catch (_) {
        // If not a user model, assuming it is just a message but not checking verification
        throw ServerException(message: "Unexpected response", statusCode: 200);
      }
    } else {
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return;
    } else {
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> verifyOtp(String email, String otp) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    }
  }

  @override
  Future<void> resendOtp(String email) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/request-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode != 200) {
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    }
  }

  @override
  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    }
  }

  @override
  Future<void> verifyResetOtp(String email, String otp) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/verify-reset-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp}),
    );

    if (response.statusCode != 200) {
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    }
  }

  @override
  Future<void> changePassword(
    String token,
    String oldPassword,
    String newPassword,
  ) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/api/users/me/password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final message = await _parseErrorMessage(response);
      throw ServerException(message: message, statusCode: response.statusCode);
    }
  }
}
