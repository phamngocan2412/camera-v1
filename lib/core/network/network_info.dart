import 'package:connectivity_plus/connectivity_plus.dart';

// Giao diện quy định
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// Lớp cài đặt cụ thể
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }
}
