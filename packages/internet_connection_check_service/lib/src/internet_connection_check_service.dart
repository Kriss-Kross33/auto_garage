import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

/// InternetConnectionCheckService is a service that checks
/// if the device is connected to the internet.
enum ConnectionStatus {
  /// The device is connected to the internet.
  connected,

  /// The device is not connected to the internet.
  disconnected,
}

/// {@template internet_connection_check_service}
/// check internet connection package
/// {@endtemplate}
class InternetConnectionCheckService {
  /// {@macro internet_connection_check_service}]

  /// check stream internet connection
  ///
  /// return [ConnectionStatus] which indicates internet connection status
  Stream<ConnectionStatus> checkInternetConnection() async* {
    final customInstance = InternetConnectionChecker();

    yield* customInstance.onStatusChange.asyncMap((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          return ConnectionStatus.connected;
        case InternetConnectionStatus.disconnected:
          return ConnectionStatus.disconnected;
      }
    });
  }

  /// {@macro internet_connection_check_service}]

  /// check if the device is connected to the internet
  ///
  /// return [bool] which indicates if the device is connected to the internet
  /// or not
  static Future<bool> get hasConnection async {
    return InternetConnectionChecker().hasConnection;
  }
}
