import 'package:platform_device_id/platform_device_id.dart';

class User {
  Future<String> getAuthor() {
    return PlatformDeviceId.getDeviceId;
  }
}
