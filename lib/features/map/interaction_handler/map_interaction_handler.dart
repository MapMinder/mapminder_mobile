import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapminder_mobile/features/map/notifier/map_notifier.dart';
import 'package:mapminder_mobile/features/map/repository/map_repository.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/screen/reminder_detail_screen.dart';
import 'package:mapminder_mobile/features/reminder/screen/reminder_form_screen.dart';
import 'package:provider/provider.dart';

class MapInteractionHandler{
  final bool Function() isMounted;

  MapInteractionHandler({
    required this.isMounted
  });

  final mapRepository = MapRepository();

  void showReminderDetailScreen(BuildContext context,Reminder reminder) async {
    final LatLng position = LatLng(reminder.latitude, reminder.longitude);
    final displayName = await mapRepository.getLocationInformation(position);
    if (displayName == null) return;
    if (!isMounted()) return;
    final result = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      isScrollControlled: true,
      isDismissible: false,
      context: context, 
      builder: (BuildContext bottomSheetContext) {
        return ReminderDetailScreen(
          locationName: displayName,
          reminder: reminder,
          onUpdate: (updatedReminder){
            Provider.of<MapNotifier>(context, listen: false).updateReminder(
              updatedReminder, 
              position, 
              () => showReminderDetailScreen(context, updatedReminder)
            );
          },
        );
      },
    );
    if (result != null) {
      if (!isMounted()) return;
      Provider.of<MapNotifier>(context, listen: false).deleteReminder(result);
    }
  }


  void addMarkerOnLongPress(BuildContext context,LatLng position) async {
    final displayName = await mapRepository.getLocationInformation(position);
    if (displayName == null) return;
    if (!isMounted()) return;
    final Reminder? result = await showModalBottomSheet (
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      isScrollControlled: true,
      isDismissible: false,
      context: context, 
      builder: (BuildContext bottomSheetContext) {
        return ReminderFormScreen(latLang: position, displayName: displayName);
      },
    );

    if (result != null) {
      if (!isMounted()) return;
      Provider.of<MapNotifier>(context, listen: false).addReminder(result, position, () => showReminderDetailScreen(context, result));
    }
  }

  void loadUserReminders(BuildContext context) async {
    try {
      if (!isMounted()) return;
      Provider.of<MapNotifier>(context, listen: false).loadUserReminders((reminder) => () => showReminderDetailScreen(context, reminder));
    } catch (e) {
      if (!isMounted()) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong when loading your reminder's... please restart your app")),
      );
    }
  }
}
