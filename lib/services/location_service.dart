import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationService {
  /// Request camera permission at app start
  static Future<bool> requestCameraPermission() async {
    try {
      ph.PermissionStatus status = await ph.Permission.camera.status;

      if (status.isDenied) {
        status = await ph.Permission.camera.request();
        if (status.isDenied) {
          return false;
        }
      }

      if (status.isPermanentlyDenied) {
        return false;
      }

      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Request location permission at app start
  static Future<bool> requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Get current location with proper error handling
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get position with timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Location timeout');
        },
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Check if location permission is denied forever
  static Future<bool> isLocationPermissionDeniedForever() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.deniedForever;
    } catch (e) {
      return false;
    }
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    return await ph.openAppSettings();
  }

  /// Show dialog to request location permission or open settings
  static Future<bool> showLocationPermissionDialog(BuildContext context) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('إذن الموقع مطلوب'),
          content: const Text(
            'يجب منح إذن الموقع لحفظ الفاتورة. يرجى منح الإذن أو فتح الإعدادات.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                // Try requesting permission again
                bool granted = await requestLocationPermission();
                if (granted) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(true);
                } else {
                  // If still denied, check if denied forever
                  bool deniedForever =
                      await isLocationPermissionDeniedForever();
                  if (deniedForever) {
                    // Open app settings
                    await ph.openAppSettings();
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(false);
                }
              },
              child: const Text('منح الإذن'),
            ),
            TextButton(
              onPressed: () async {
                await ph.openAppSettings();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(false);
              },
              child: const Text('فتح الإعدادات'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
