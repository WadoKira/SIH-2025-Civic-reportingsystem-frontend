import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/issue_provider.dart';
import '../../services/location_service.dart';
import '../../models/issue_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  LatLng _center = const LatLng(28.6139, 77.2090); // Default to Delhi

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadIssueMarkers();
  }

  Future<void> _getCurrentLocation() async {
    print('Getting current location...');
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      print('Location found: ${position.latitude}, ${position.longitude}');
      final newCenter = LatLng(position.latitude, position.longitude);
      setState(() {
        _center = newCenter;
      });
      _mapController.move(newCenter, 15.0);
    } else {
      print('Location not found');
    }
  }

  void _loadIssueMarkers() {
    final issues = Provider.of<IssueProvider>(context, listen: false).issues;
    setState(() {
      _markers.clear();
      for (var issue in issues) {
        _markers.add(
          Marker(
            point: LatLng(issue.latitude, issue.longitude),
            child: Icon(
              Icons.location_pin,
              color: _getMarkerColor(issue.priority),
              size: 40,
            ),
          ),
        );
      }
    });
  }

  Color _getMarkerColor(IssuePriority priority) {
    switch (priority) {
      case IssuePriority.low:
        return Colors.green;
      case IssuePriority.medium:
        return Colors.orange;
      case IssuePriority.high:
        return Colors.red;
      case IssuePriority.critical:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issues Map'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadIssueMarkers,
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.civic_reporter_new',
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}