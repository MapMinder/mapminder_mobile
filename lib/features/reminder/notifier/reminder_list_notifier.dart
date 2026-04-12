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
}
