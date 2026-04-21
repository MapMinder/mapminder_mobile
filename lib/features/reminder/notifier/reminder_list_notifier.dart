import 'package:flutter/material.dart';
import 'package:mapminder_mobile/features/reminder/controller/reminder_controller.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';

class ReminderListNotifier extends ChangeNotifier {
  ReminderListNotifier();

  List<Reminder>? _reminders;
  final reminderContorller = ReminderController();

  List<Reminder>? getReminders() {
    return _reminders;
  }

  void getRemindersWithStatus(ReminderStatus status) async {
    _reminders = await reminderContorller.getRemindersWithStatus(status);
    notifyListeners();
  }

  void getAllReminders() async {
    _reminders = await reminderContorller.getAllReminders(); 
    notifyListeners();
  }

  void updateReminderStatus(String reminderId, ReminderStatus status, bool isFiltered) async {
    Reminder reminder = await reminderContorller.updateReminderStatus(reminderId, status);
    int? index = _reminders?.indexWhere((r) => r.reminderId == reminderId);
    if (isFiltered) {
      _reminders?.removeWhere((r) => r.reminderId == reminderId);
    } else if (index != null) {
      _reminders?[index] = reminder;
    }
    notifyListeners();
  }

  void deleteReminder(String reminderId) async {
    await reminderContorller.deleteReminder(reminderId);
    _reminders?.removeWhere((r) => r.reminderId == reminderId);
    notifyListeners();
  }
}
