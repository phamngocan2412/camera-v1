// core/errors/exceptions.dart – PHIÊN BẢN HOÀN HẢO 2025
abstract class AppException implements Exception {
  final String? message;
  final int? statusCode;
  const AppException({this.message, this.statusCode});

  @override
  String toString() {
    if (message != null) return message!;
    return 'Server Error ${statusCode != null ? "($statusCode)" : ""}';
  }
}

// Lỗi từ server (API trả về 4xx, 5xx)
class ServerException extends AppException {
  const ServerException({super.message, super.statusCode});
}

class NotFoundException extends ServerException {
  const NotFoundException()
    : super(message: 'Không tìm thấy tài nguyên', statusCode: 404);
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException()
    : super(message: 'Phiên đăng nhập hết hạn', statusCode: 401);
}

class BadRequestException extends ServerException {
  const BadRequestException([String? message])
    : super(message: message ?? 'Yêu cầu không hợp lệ', statusCode: 400);
}

class VerificationPendingException extends ServerException {
  const VerificationPendingException({super.message}) : super(statusCode: 200);
}

// Lỗi mạng – RIÊNG BIỆT
class NetworkException implements Exception {
  final String? message;
  const NetworkException([this.message = 'Không có kết nối mạng']);

  @override
  String toString() => message!;
}

// Cache & Validation
class CacheException implements Exception {
  final String? message;
  const CacheException([this.message]);
}

class ValidationException implements Exception {
  final String? message;
  const ValidationException([this.message]);
}

/*
Phần lõi của Clean Architecture

Hai nhóm Exception và Failure liên quan chặt chẽ với nhau, 
nhưng hoàn toàn khác vai trò.

Với Exception : 
- Đây là lỗi kỹ thuật (technical error)
- Nó xảy ra khi làm việc với hệ thống, ví dụ : Gọi API bị timeout, lỗi HTTP 500,
Đọc/ghi cache thất bại, Không kết nối được mạng.

Dùng ở vị trí Data Layer
*/
