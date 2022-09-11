import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}


class NetworkInfoImpl implements NetworkInfo {
  // final connectionChecker = InternetConnectionChecker();
  final connectionChecker = InternetConnectionCheckerPlus();

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
