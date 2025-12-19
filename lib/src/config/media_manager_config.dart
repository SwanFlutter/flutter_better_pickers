import 'package:flutter/foundation.dart';
import 'package:media_manager/media_manager.dart';

/// Configuration class for MediaManager performance settings
class MediaManagerConfig {
  static bool _isolatesEnabled = false;

  /// Enable/disable isolates for heavy operations
  /// Call this in your app's initState
  static void configurePerformance({bool useIsolates = true}) {
    _isolatesEnabled = useIsolates;
    MediaManager.setIsolateUsage(useIsolates);
    debugPrint(
      '🏃 Isolates ${useIsolates ? 'enabled' : 'disabled'} for heavy operations',
    );
  }

  /// Check if isolates are currently enabled
  static bool get isolatesEnabled => _isolatesEnabled;

  /// Toggle isolates on/off
  static void toggleIsolates() {
    configurePerformance(useIsolates: !_isolatesEnabled);
  }

  /// Clean up isolate resources
  /// Call this in your app's dispose or when app goes to background
  static void cleanup() {
    MediaManager.disposeIsolates();
    debugPrint('🧹 Isolate resources cleaned up');
  }
}
