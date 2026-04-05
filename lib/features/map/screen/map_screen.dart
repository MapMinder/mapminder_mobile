import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapminder_mobile/core/loading.dart';
import 'package:mapminder_mobile/features/auth/services/logout_service.dart';
import 'package:mapminder_mobile/features/map/repository/map_repository.dart';
import 'package:mapminder_mobile/features/map/services/map_style_services.dart';
import 'package:mapminder_mobile/features/reminder/controller/reminder_controller.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/screen/reminder_detail_screen.dart';
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
  List<Reminder>? reminders;

  // default position of map at start up
  // TODO: Replace with environ variables
  final LatLng _center = const LatLng(35.493057, 139.668340);
  final double _zoom = 10.0;

  final logoutService = LogoutService();
  final mapRepository = MapRepository();
  final reminderController = ReminderController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // load dark map style for map
  // v0.0.1 supoprt's only dark mode
  @override
  void initState() {
    super.initState();
    _loadStyle();
    _loadUserReminders();
  }

  void _showReminderDetailScreen(Reminder reminder) async {
    if (!mounted) return;
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      isScrollControlled: true,
      isDismissible: false,
      context: context, 
      builder: (BuildContext context) {
        return ReminderDetailScreen(
          reminder: reminder,
          onUpdate: (updatedReminder){
            final index = reminders!.indexWhere(
              (r) => r.reminderId == updatedReminder.reminderId
            );
            if (index == -1) return;
            final markerId = MarkerId(updatedReminder.reminderId);
            setState(() {
              reminders![index] = updatedReminder;
              _markers[markerId] = Marker(
                onTap: () => _showReminderDetailScreen(updatedReminder),
                markerId: markerId, 
                position: LatLng(updatedReminder.latitude, updatedReminder.longitude)
              );
            });
          },
        );
      },
    );
  }

  void _loadUserReminders() async {
    try {
      reminders = await reminderController.getAllReminders();
      if (!mounted) return;
      setState(() {
        for (var reminder in reminders!) {
          final markerId = MarkerId(reminder.reminderId);
          final Marker usersMarkers = Marker(
            onTap: () => _showReminderDetailScreen(reminder),
            markerId: markerId, 
            position: LatLng(reminder.latitude, reminder.longitude)
          );
          _markers[markerId] = usersMarkers;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong when loading your reminder's... please restart your app")),
      );
    }
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

  void _addMarkerLongPress(LatLng latLang) async {
    final displayName = await mapRepository.getLocationInformation(latLang);
    if (displayName == null) return;
    if (!mounted) return;
    final result = await showModalBottomSheet (
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
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
    // render map
    return Loading(
      isLoading: _mapStyle == null || reminders == null,
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
      ),
    );
  }
}
