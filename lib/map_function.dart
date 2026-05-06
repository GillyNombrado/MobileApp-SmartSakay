import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/splash_screen.dart';

// ─── ENUMS ────────────────────────────────────────────────────────────────────

enum MapType { street, satellite, terrain }

enum MenuType { home, directions, settings }

// ─── TILE URLs ────────────────────────────────────────────────────────────────

const Map<MapType, String> mapTileUrls = {
  MapType.street: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  MapType.satellite:
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
  MapType.terrain: 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
};

// ─── MAP FUNCTIONS MIXIN ──────────────────────────────────────────────────────

mixin MapFunctions<T extends StatefulWidget> on State<T> {
  // ── Controllers & state ───────────────────────────────────────────────────
  final MapController mapController = MapController();
  final List<Marker> markers = [];
  final List<LatLng> routePoints = [];

  LatLng currentPosition = const LatLng(14.5995, 120.9842);
  bool isLoading = true;
  bool isTracking = false;

  // Holds the active stream so we can cancel it when tracking is turned off.
  StreamSubscription<Position>? _trackingSubscription;

  MapType currentMapType = MapType.street;

  // ─── PERMISSIONS & LOCATION ───────────────────────────────────────────────

  Future<void> initLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      await getUserLocation();
    } else if (status.isPermanentlyDenied) {
      showPermissionDialog();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> getUserLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final userLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        currentPosition = userLatLng;
        isLoading = false;
      });

      addUserMarker(userLatLng);
      animateTo(userLatLng);
    } catch (e) {
      setState(() => isLoading = false);
      showMapSnackBar('Could not get location: $e');
    }
  }

  // ── Toggle: call once to START, call again to STOP ────────────────────────
  void toggleLiveTracking() {
    if (isTracking) {
      _stopLiveTracking();
    } else {
      _startLiveTracking();
    }
  }

  void _startLiveTracking() {
    setState(() {
      isTracking = true;
      routePoints.clear(); // fresh path each time tracking starts
    });

    _trackingSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // update every 5 metres
      ),
    ).listen((Position position) {
      final newPos = LatLng(position.latitude, position.longitude);
      setState(() {
        currentPosition = newPos;
        routePoints.add(newPos);
      });
      addUserMarker(newPos);
      animateTo(newPos);
    });

    showMapSnackBar('📍 Live tracking started');
  }

  void _stopLiveTracking() {
    _trackingSubscription?.cancel();
    _trackingSubscription = null;

    setState(() => isTracking = false);
    showMapSnackBar('⏹️ Live tracking stopped');
  }

  // Call this in your State's dispose() to avoid memory leaks.
  void disposeTracking() {
    _trackingSubscription?.cancel();
    _trackingSubscription = null;
  }

  // ─── MARKERS ──────────────────────────────────────────────────────────────

  void addUserMarker(LatLng position) {
    setState(() {
      markers.removeWhere((m) => m.key == const ValueKey('user'));
      markers.add(
        Marker(
          key: const ValueKey('user'),
          point: position,
          width: 60,
          height: 60,
          child: const Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
              Text(
                'You',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    });
  }

  void addCustomMarker(LatLng position) {
    final markerId = ValueKey('pin_${position.latitude}_${position.longitude}');
    setState(() {
      markers.add(
        Marker(
          key: markerId,
          point: position,
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () => showMarkerInfo(position),
            child: const Icon(Icons.location_pin, color: Colors.red, size: 45),
          ),
        ),
      );
    });
    showMapSnackBar('📍 Marker added!');
  }

  // ─── MAP CONTROLS ─────────────────────────────────────────────────────────

  void animateTo(LatLng position, {double zoom = 15}) {
    mapController.move(position, zoom);
  }

  void zoomIn() {
    mapController.move(
      mapController.camera.center,
      mapController.camera.zoom + 1,
    );
  }

  void zoomOut() {
    mapController.move(
      mapController.camera.center,
      mapController.camera.zoom - 1,
    );
  }

  void clearAll() {
    setState(() {
      markers.clear();
      routePoints.clear();
    });
    showMapSnackBar('🗑️ Cleared all markers and routes');
  }

  // ─── DIALOGS & SNACKBARS ──────────────────────────────────────────────────

  BuildContext get mapContext => context;

  void showMapSnackBar(String message) {
    ScaffoldMessenger.of(mapContext).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void showMarkerInfo(LatLng position) {
    showModalBottomSheet(
      context: mapContext,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📍 Pinned Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Latitude:  ${position.latitude.toStringAsFixed(6)}'),
            Text('Longitude: ${position.longitude.toStringAsFixed(6)}'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => markers.removeWhere((m) => m.point == position));
                Navigator.pop(mapContext);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Remove Marker'),
            ),
          ],
        ),
      ),
    );
  }

  void showPermissionDialog() {
    showDialog(
      context: mapContext,
      builder: (_) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'Please enable location access in settings to use the map.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(mapContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(mapContext);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog(VoidCallback onConfirm) {
    showDialog(
      context: mapContext,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(mapContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(mapContext);
              onConfirm();
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void logoutAndGoToLogin() {
    Navigator.pushAndRemoveUntil(
      mapContext,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }
}