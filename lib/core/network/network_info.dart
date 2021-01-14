import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetWorkInfo {
  Future<bool> isConnected();
}

class NetWorkInfoImpl extends NetWorkInfo {
  final DataConnectionChecker connectionChecker;

  NetWorkInfoImpl({this.connectionChecker});

  @override
  Future<bool> isConnected() => connectionChecker.hasConnection;
}
