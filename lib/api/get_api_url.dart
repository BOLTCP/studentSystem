import 'dart:io' as io;
import 'package:flutter/foundation.dart';

Uri getApiUrl([String endpoint = '']) {
  String baseUrl;

  if (kIsWeb) {
    baseUrl = 'http://localhost:54422'; // Localhost for web (you can customize this as needed)
  } else if (io.Platform.isAndroid) {
    baseUrl = 'http://10.0.2.2:54422'; // Android Emulator
  } else if (io.Platform.isIOS) {
    baseUrl = 'http://localhost:54422'; // Localhost for iOS
  } else {
    throw UnsupportedError('This platform is not supported yet');
  }

  return Uri.parse('$baseUrl$endpoint'); // Append the endpoint to the base URL
}
