import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetWorkInfo {
  Future<bool> isConnected();
}

class NetWorkInfoImpl extends NetWorkInfo {
  final InternetConnectionChecker? connectionChecker;

  NetWorkInfoImpl({this.connectionChecker});

  @override
  Future<bool> isConnected() => connectionChecker!.hasConnection;
}
