import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;
  final List<Object> properties;

  const Failure([this.message, this.properties = const <Object>[]]);

  @override
  List<Object?> get props => [message, ...properties];
}

// Server Failure - Lỗi từ phía server/backend
class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

// Cache Failure - Lỗi liên quan đến local cache
class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

// No Connection Failure - Lỗi không có kết nối mạng

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

// Validation Failure - Lỗi validation dữ liệu

class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

// Not Found Failure - Lỗi không tìm thấy resource
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

// Permission Failure - Lỗi không có quyền
class PermissionFailure extends Failure {
  const PermissionFailure([super.message]);
}

// Unknown Failure - Lỗi không xác định
class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message]);
}

class VerificationPendingFailure extends Failure {
  const VerificationPendingFailure([super.message]);
}

// Đây là nơi bạn định nghĩa các loại failure có thể xảy ra trong tầng logic,
// tách biệt hoàn toàn với UI hoặc Exception của hệ thống

// Tại sao không dùng Exception hoặc Error trực tiếp ?
/* 
- Exception của Dart thường chứa thông tin kỹ thuật (khó dùng cho UI).
- Muốn ánh xạ lỗi kỹ thuật thành lỗi nghiệp vụ (business failure) có ý nghĩa cho ứng dụng.
- Vị trí Domain Layer
Rep bắt Exp -> chuyển sang Fai nghiệp vụ -> Cuối cùng trả về cho UC/BLoC/UI
*/
