import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
        const Text(
          'Plan your trip',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: fromController,
          decoration: const InputDecoration(
            hintText: 'Your location',
            prefixIcon: Icon(Icons.my_location, color: Colors.blue),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: toController,
          decoration: const InputDecoration(
            hintText: 'Destination',
            prefixIcon: Icon(Icons.location_on, color: Colors.red),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: vehicle,
                decoration: const InputDecoration(
                  labelText: 'Vehicle',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: ['Any', 'Jeep', 'Bus', 'Tricycle']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => vehicle = val!),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: preference,
                decoration: const InputDecoration(
                  labelText: 'Preference',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: ['Fastest', 'Cheapest']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => preference = val!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              if (fromController.text.isEmpty || toController.text.isEmpty) {
                showMapSnackBar('Please fill in both locations');
                return;
              }
              addHistory(
                'Route: ${fromController.text} → ${toController.text} | $vehicle | $preference',
              );
              showMapSnackBar('🔍 Finding route...');
              // Switch to directions after searching
              setState(() => currentMenu = MenuType.directions);
            },
            icon: const Icon(Icons.search),
            label: const Text('Find Route'),
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
              leading: CircleAvatar(child: Text('3')),
              title: Text('Terminal'),
            ),
          ],
        );

      case MenuType.terminal:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terminals',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.directions_bus, color: Colors.orange),
              title: Text('SM San Pablo Terminal'),
            ),
            ListTile(
              leading: Icon(Icons.directions_bus, color: Colors.orange),
              title: Text('Central Terminal'),
            ),
          ],
        );

      case MenuType.landmarks:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Landmarks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.store, color: Colors.purple),
              title: Text('SM San Pablo'),
            ),
            ListTile(
              leading: Icon(Icons.account_balance, color: Colors.purple),
              title: Text('City Hall'),
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket, color: Colors.purple),
              title: Text('Public Market'),
            ),
          ],
        );

      case MenuType.history:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (navHistory.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No recent routes yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...navHistory.map(
                (e) => ListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(e, style: const TextStyle(fontSize: 13)),
                ),
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
              leading: const Icon(Icons.brightness_6, color: Colors.blueGrey),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (val) {
                  // This is just a placeholder. Implementing theme switching
                  // would require lifting state up to MaterialApp.
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
      (MenuType.terminal, Icons.directions_bus, 'Terminal'),
      (MenuType.landmarks, Icons.place, 'Landmarks'),
      (MenuType.history, Icons.history, 'History'),
      (MenuType.settings, Icons.settings, 'Settings'),
    ];

    return BottomNavigationBar(
      currentIndex: MenuType.values.indexOf(currentMenu),
      onTap: (i) => setState(() => currentMenu = MenuType.values[i]),
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF1EC6A4),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      items: items
          .map(
            (item) =>
                BottomNavigationBarItem(icon: Icon(item.$2), label: item.$3),
          )
          .toList(),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1EC6A4),
        elevation: 0,
        title: const Text('Smart Sakay'),
        actions: [
          PopupMenuButton<MapType>(
            icon: const Icon(Icons.layers),
            onSelected: (type) => setState(() => currentMapType = type),
            itemBuilder: (_) => const [
              PopupMenuItem(value: MapType.street, child: Text('🗺️ Street')),
              PopupMenuItem(
                value: MapType.satellite,
                child: Text('🛰️ Satellite'),
              ),
              PopupMenuItem(value: MapType.terrain, child: Text('⛰️ Terrain')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all',
            onPressed: clearAll,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // ── MAP ──
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: currentPosition,
                    initialZoom: 15,
                    onTap: (_, latLng) => addCustomMarker(latLng),
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

                // ── BOTTOM SHEET PANEL (rendered before controls so it sits below them) ──
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

                // ── LIVE TRACKING BADGE (top-left, never overlaps anything) ──
                if (isTracking)
                  Positioned(
                    top: 12,
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

                Positioned(
                  right: 20,
                  bottom: 308,
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

                // ── FABs (right side, above collapsed sheet + nav bar) ──
                Positioned(
                  right: 16,
                  bottom: 170,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        heroTag: 'track',
                        onPressed: isTracking ? null : startLiveTracking,
                        backgroundColor: isTracking
                            ? Colors.grey
                            : Colors.green,
                        child: const Icon(Icons.navigation),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: 'locate',
                        onPressed: getUserLocation,
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),

                // ── COORDINATES (left side, same level as FABs) ──
                Positioned(
                  left: 12,
                  bottom: 170,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${currentPosition.latitude.toStringAsFixed(5)}, '
                      '${currentPosition.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),

      // ── BOTTOM NAV ──
      bottomNavigationBar: isLoading ? null : _buildBottomNav(),
    );
  }
}
