import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Check the current status of connectivity
  Future<bool> checkConnection() async {
    try {
      var connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false; // Return false if there's an error
    }
  }

  // Listen for connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((connectivityResult) {
      return connectivityResult != ConnectivityResult.none;
    });
  }
}
