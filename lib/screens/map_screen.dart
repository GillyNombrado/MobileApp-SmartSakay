import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import '../map_function.dart';

// ─── SCREEN ───────────────────────────────────────────────────────────────────

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with MapFunctions<MapScreen> {
  // ── Bottom Sheet / Navigation ──
  MenuType currentMenu = MenuType.home;
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  String vehicle = 'Any';
  String preference = 'Fastest';
  final List<String> navHistory = [];

  @override
  void initState() {
    super.initState();
    initLocationPermission();
  }

  @override
  void dispose() {
    disposeTracking(); // cancels GPS stream — prevents memory leak
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void addHistory(String entry) {
    setState(() => navHistory.insert(0, entry));
  }

  // ─── BOTTOM SHEET CONTENT ─────────────────────────────────────────────────

  Widget homeSheet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan your trip',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: const Color(0xFF213A58),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        _ModernMapField(
          controller: fromController,
          hint: 'Your location',
          icon: Icons.my_location,
          iconColor: const Color(0xFF09D1C7),
        ),
        const SizedBox(height: 12),
        _ModernMapField(
          controller: toController,
          hint: 'Destination',
          icon: Icons.location_on,
          iconColor: Colors.redAccent,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ModernDropdown(
                value: vehicle,
                label: 'Transport Mode',
                items: ['Any', 'Jeep', 'Bus', 'Tricycle'],
                onChanged: (val) => setState(() => vehicle = val!),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ModernDropdown(
                value: preference,
                label: 'Preference',
                items: ['Fastest', 'Cheapest'],
                onChanged: (val) => setState(() => preference = val!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              if (fromController.text.isEmpty || toController.text.isEmpty) {
                showMapSnackBar('Please fill in both locations');
                return;
              }
              addHistory(
                'Route: ${fromController.text} → ${toController.text} | $vehicle | $preference',
              );
              showMapSnackBar('🔍 Finding route...');
              setState(() => currentMenu = MenuType.directions);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF09D1C7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF09D1C7).withOpacity(0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Find Route',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sheetContent() {
    switch (currentMenu) {
      case MenuType.home:
        return homeSheet();

      case MenuType.directions:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Directions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(child: Text('1')),
              title: Text('Walk'),
            ),
            ListTile(
              leading: CircleAvatar(child: Text('2')),
              title: Text('Tricycle'),
            ),
            ListTile(
              leading: CircleAvatar(child: Text('3')),
              title: Text('Jeep'),
            ),
            ListTile(
              leading: CircleAvatar(child: Text('4')),
              title: Text('Terminal'),
            ),
          ],
        );

      case MenuType.settings:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.grey),
              title: const Text('History'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.brightness_6, color: Colors.blueGrey),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (val) {
                  showMapSnackBar('Theme switching not implemented');
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => showLogoutDialog(logoutAndGoToLogin),
            ),
          ],
        );
    }
  }

  // ─── BOTTOM NAV BAR ───────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    final items = [
      (MenuType.home, Icons.home, 'Home'),
      (MenuType.directions, Icons.directions, 'Directions'),
      (MenuType.settings, Icons.settings, 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: MenuType.values.indexOf(currentMenu),
        onTap: (i) => setState(() => currentMenu = MenuType.values[i]),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF213A58),
        selectedItemColor: const Color(0xFF09D1C7),
        unselectedItemColor: Colors.white.withOpacity(0.5),
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
        elevation: 0,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.$2),
              label: item.$3,
            ),
          )
          .toList(),
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isLoading
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Smart Sakay',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              backgroundColor: const Color(0xFF0C6478),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.layers_outlined, color: Colors.white),
                  onPressed: () {
                    // Toggle map type
                    setState(() {
                      if (currentMapType == MapType.street) {
                        currentMapType = MapType.satellite;
                      } else if (currentMapType == MapType.satellite) {
                        currentMapType = MapType.terrain;
                      } else {
                        currentMapType = MapType.street;
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: clearAll,
                ),
                const SizedBox(width: 8),
              ],
            ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF09D1C7)),
            )
          : Stack(
              children: [
                // ── MAP ──────────────────────────────────────────────────────
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: currentPosition,
                    initialZoom: 15,
                    onTap: (tapPos, point) => addCustomMarker(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: mapTileUrls[currentMapType]!,
                      userAgentPackageName: 'com.example.app',
                    ),
                    if (routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            color: Colors.blue,
                            strokeWidth: 4,
                          ),
                        ],
                      ),
                    MarkerLayer(markers: markers),
                  ],
                ),

                // ── BOTTOM SHEET ──────────────────────────────────────────────
                // Rendered before all Positioned widgets so controls paint on top.
                DraggableScrollableSheet(
                  initialChildSize: 0.35,
                  minChildSize: 0.12,
                  maxChildSize: 0.75,
                  builder: (_, scrollController) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        sheetContent(),
                      ],
                    ),
                  ),
                ),

                // ── COORDINATES (top-left, below AppBar) ─────────────────────
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${currentPosition.latitude.toStringAsFixed(5)},\n'
                      '${currentPosition.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),

                // ── ZOOM CONTROLS (right, middle of screen) ───────────────────
                Positioned(
                  right: 16,
                  top: 140,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        onPressed: zoomIn,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        onPressed: zoomOut,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),

                // ── TRACK + LOCATE FABs (top-right) ───────────────────────────
                // Track FAB: green = off, red = on. Tap toggles the GPS stream.
                Positioned(
                  right: 16,
                  top: 12,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'track',
                        onPressed: toggleLiveTracking,
                        backgroundColor:
                            isTracking ? Colors.red : Colors.green,
                        tooltip: isTracking
                            ? 'Stop live tracking'
                            : 'Start live tracking',
                        child: Icon(
                          isTracking ? Icons.gps_off : Icons.navigation,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'locate',
                        onPressed: getUserLocation,
                        child: const Icon(Icons.my_location, size: 20),
                      ),
                    ],
                  ),
                ),

                // ── LIVE TRACKING BADGE (top-left, below coordinates) ─────────
                // Only visible when tracking is active.
                if (isTracking)
                  Positioned(
                    top: 60,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.gps_fixed, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Live Tracking',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

      // ── BOTTOM NAV ───────────────────────────────────────────────────────
      bottomNavigationBar: isLoading ? null : _buildBottomNav(),
    );
  }
}

// ─── HELPER WIDGETS ──────────────────────────────────────────────────────────

class _ModernMapField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color iconColor;

  const _ModernMapField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 15),
          prefixIcon: Icon(icon, color: iconColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _ModernDropdown extends StatelessWidget {
  final String value;
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _ModernDropdown({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
            border: InputBorder.none,
          ),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}