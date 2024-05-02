import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus? cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus? microphonePermissionStatus = await _getMicrophonePermission();
    print(cameraPermissionStatus.toString()+"hhh"+microphonePermissionStatus.toString());
    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus!, microphonePermissionStatus!);
      return false;
    }
  }

  // static Future<PermissionStatus?> _getCameraPermission() async {
  //   PermissionStatus permission =await Permission.camera.request();
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.denied) {
  //         Map<Permission, PermissionStatus> permissionStatus =await [Permission.camera].request();
  //     return permissionStatus[Permission.camera] ??
  //         permissionStatus[Permission.unknown];
  //   } else {
  //     return permission;
  //   }
  // }

    static Future<PermissionStatus?> _getCameraPermission() async {
          Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.camera].request();
    PermissionStatus? permission = await permissionStatus[Permission.camera];
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      return permissionStatus[Permission.camera] ??
          permissionStatus[Permission.unknown];
    } else {
      return permission;
    }
  }

   static Future<PermissionStatus?> _getMicrophonePermission() async {
          Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.microphone].request();
    PermissionStatus? permission = await permissionStatus[Permission.microphone];
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      return permissionStatus[Permission.microphone] ??
          permissionStatus[Permission.unknown];
    } else {
      return permission;
    }
  }



  // static Future<PermissionStatus?> _getMicrophonePermission() async {
  //   PermissionStatus permission = await Permission.microphone.status;
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.denied) {
  //     Map<Permission, PermissionStatus> permissionStatus =
  //         await [Permission.microphone].request();
  //     return permissionStatus[Permission.microphone] ??
  //         permissionStatus[Permission.unknown];
  //   } else {
  //     return permission;
  //   }
  // }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }
}
