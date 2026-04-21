import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapminder_mobile/core/loading.dart';
import 'package:mapminder_mobile/features/auth/services/logout_service.dart';
import 'package:mapminder_mobile/features/map/notifier/map_notifier.dart';
import 'package:mapminder_mobile/features/map/services/map_style_services.dart';
import 'package:mapminder_mobile/features/map/interaction_handler/map_interaction_handler.dart';
import 'package:mapminder_mobile/features/reminder/notifier/reminder_list_notifier.dart';
import 'package:mapminder_mobile/features/reminder/screen/reminder_list_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _mapStyle;
  late GoogleMapController mapController;

  // default position of map at start up
  // TODO: Replace with environ variables
  final LatLng _center = const LatLng(35.493057, 139.668340);
  final double _zoom = 10.0;


  late final MapInteractionHandler mapInteractionHandler;
  final logoutService = LogoutService();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // load dark map style for map
  // v0.0.1 supoprt's only dark mode
  @override
  void initState() {
    super.initState();
    _loadStyle();
    mapInteractionHandler = MapInteractionHandler(isMounted: () => mounted);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapInteractionHandler.loadUserReminders(context);
    });
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
        SnackBar(content: Text("Something went wrong.. Could you retry again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // when mapStyle is not provided return loading indicator
    // render map
    return Consumer<MapNotifier>(
      builder: (context, mapNotifier, child) {
        return Loading(
        isLoading: _mapStyle == null || mapNotifier.getReminders() == null,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              style: _mapStyle ?? '',
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: _zoom
              ),
              markers: mapNotifier.getMarkers(),
              onLongPress: (position) => mapInteractionHandler.addMarkerOnLongPress(context, position),
            ),
            // FIX: fix this when the reminder feature is implemented
            Center(
              child: ElevatedButton(
                onPressed: logout, 
                child: Text("logout"),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: false,
                    context: context, 
                    builder: (BuildContext bottomSheetContext) {
                      return ChangeNotifierProvider(
                        create: (context) => ReminderListNotifier(),
                        child: ReminderListScreen(),
                      );
                    }
                    );
                },
                icon: const Icon(Icons.menu),
                label: const Text("Reminders"),
              ),
            )
          ],
        ),
      );
      },
    );
  }
}
