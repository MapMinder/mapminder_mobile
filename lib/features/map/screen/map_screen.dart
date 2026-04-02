import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapminder_mobile/features/auth/services/logout_service.dart';
import 'package:mapminder_mobile/features/map/repository/map_repository.dart';
import 'package:mapminder_mobile/features/map/services/map_style_services.dart';
import 'package:mapminder_mobile/features/reminder/screen/reminder_form_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _mapStyle;
  late GoogleMapController mapController;
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  // default position of map at start up
  // TODO: Replace with environ variables
  final LatLng _center = const LatLng(35.493057, 139.668340);
  final double _zoom = 10.0;

  final logoutService = LogoutService();
  final mapRepository = MapRepository();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  // load dark map style for map
  // v0.0.1 supoprt's only dark mode
  @override
  void initState() {
    super.initState();
    _loadStyle();
  }

  void _loadStyle() async {
    final style = await MapStyleServices.loadDarkStyle();
    setState(() {
      _mapStyle = style;
    });
  }

  // TODO: move this to the login controller
  void logout() async {
    try {
      await logoutService.logout();
      if (!mounted) return;
      Navigator.pushNamed(context, "/login");
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong.. Could you retry again')),
      );
    }
  }

  void _addMarkerLongPress(LatLng latLang) async {
    final displayName = await mapRepository.getLocationInformation(latLang);
    if (displayName == null) return;
    if (!mounted) return;
    final result = await showModalBottomSheet (
      isScrollControlled: true,
      isDismissible: false,
      context: context, 
      builder: (BuildContext context) {
        return ReminderFormScreen(latLang: latLang, displayName: displayName);
      },
    );
    if (result != null) {
      final MarkerId markerId = MarkerId('$result');
      final Marker marker = Marker(markerId: markerId, position: latLang);
      if (!mounted) return;
      setState(() {
        _markers[markerId] = marker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // when mapStyle is not provided return loading indicator
    if (_mapStyle == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // render map
    return Stack(
      children: <Widget>[
        GoogleMap(
          style: _mapStyle,
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: _zoom
          ),
          markers: Set<Marker>.of(_markers.values),
          onLongPress: _addMarkerLongPress,
        ),
        // FIX: fix this when the reminder feature is implemented
        Center(
          child: ElevatedButton(
            onPressed: logout, 
            child: Text("logout"),
          ),
        ),
      ],
    );
  }
}
