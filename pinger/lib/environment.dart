import 'package:flutter/foundation.dart' show kReleaseMode;

class Environment {
  // For production
  static const String appwriteProjectId = '';
  static const String appwriteProjectName = '';
  static const String appwritePublicEndpoint = '';
  static const String appBaseUrl = kReleaseMode
      ? 'https://'
      : 'http://localhost:3000';
}
