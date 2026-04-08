import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapminder_mobile/features/reminder/controller/reminder_controller.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';

class MapNotifier extends ChangeNotifier {

  MapNotifier();

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  List<Reminder>? _reminders;

  // TODO: this will be turned into a controller for consistency
  final reminderController = ReminderController();

  Set<Marker> getMarkers() {
    return Set<Marker>.of(_markers.values);
  }

  List<Reminder>? getReminders() {
    return _reminders;
  }

  void addReminder(Reminder reminder, LatLng position, VoidCallback onTap) {
    final MarkerId markerId = MarkerId(reminder.reminderId);
    final Marker marker = Marker(
      onTap: onTap,
      markerId: markerId, 
      position: position, 
    );

    _reminders?.add(reminder);
    _markers[markerId] = marker;
    notifyListeners();
  }

  void loadUserReminders(VoidCallback Function(Reminder) onTapBuilder) async {
    _reminders = await reminderController.getAllReminders();
    for (var reminder in _reminders!) {
      final MarkerId markerId = MarkerId(reminder.reminderId);
      final LatLng position = LatLng(reminder.latitude, reminder.longitude);
      final Marker marker = Marker(
        onTap: onTapBuilder(reminder),
        markerId: markerId, 
        position: position, 
      );
      _markers[markerId] = marker;
    }
    notifyListeners();
  }

  void updateReminder(Reminder updatedReminder, LatLng position, VoidCallback onTap) {
    final index = _reminders!.indexWhere((r) => r.reminderId == updatedReminder.reminderId);
    if (index == -1) return;
    final markerId = MarkerId(updatedReminder.reminderId);
    _reminders![index] = updatedReminder;
    _markers[markerId] = Marker(
      onTap: onTap,
      markerId: markerId,
      position: position
      );
    notifyListeners();
  }

  void deleteReminder(String reminderId) {
    _markers.remove(MarkerId(reminderId));
    _reminders?.removeWhere((reminder) => reminder.reminderId == reminderId);
    notifyListeners();
  }
}
