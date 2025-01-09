import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'constant.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Permissions {
  static PermissionHandlerPlatform get _handler => PermissionHandlerPlatform.instance;

  static Future<bool> cameraFilesAndLocationPermissionsGranted() async {
    if (!getBoolAsync(PERMISSION_STATUS)) {
      Map<Permission, PermissionStatus> cameraPermissionStatus;
      //final deviceInfo = await DeviceInfoPlugin().androidInfo;
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;
       androidInfo.version.sdkInt;

      if(androidInfo.version.sdkInt > 32){
        cameraPermissionStatus = await _handler.requestPermissions(
          [
            Permission.photos,
            Permission.camera,
          ],
        );
      }else{
        cameraPermissionStatus = await _handler.requestPermissions(
          [
            Permission.camera,
            Permission.storage,
          ],
        );
      }


      bool checkedTrue = true;
      for (var element in cameraPermissionStatus.values) {
        if (element == PermissionStatus.granted) {
          checkedTrue = true;
        } else if (element == PermissionStatus.permanentlyDenied) {
          openAppSettings();
          checkedTrue = false;
        } else {
          checkedTrue = false;
        }
      }

      return checkedTrue;
    }

    return true;
  }
}

/// Only for Location
class LocationPermissions {
  static PermissionHandlerPlatform get _handler => PermissionHandlerPlatform.instance;

  static Future<bool> locationPermissionsGranted() async {
    if (!getBoolAsync(PERMISSION_STATUS)) {
      Map<Permission, PermissionStatus> cameraPermissionStatus = await _handler.requestPermissions(
        [
          Permission.location,
          if (isIOS) Permission.locationAlways,
          if (isIOS) Permission.locationWhenInUse,
        ],
      );

      bool checkedTrue = true;
      for (var element in cameraPermissionStatus.values) {
        if (element == PermissionStatus.granted) {
          checkedTrue = true;
        } else if (element == PermissionStatus.permanentlyDenied) {
          openAppSettings();
          checkedTrue = false;
        } else {
          checkedTrue = false;
        }
      }

      return checkedTrue;
    }

    return true;
  }
}
