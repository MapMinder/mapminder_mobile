import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/dto/create_reminder_dto.dart';
import 'package:mapminder_mobile/features/reminder/dto/update_reminder_dto.dart';
import 'package:mapminder_mobile/features/reminder/services/reminder_service.dart';

class ReminderController {
  static ReminderController? _instance;

  factory ReminderController() {
    _instance ??= ReminderController._();
    return _instance!;
  }

  ReminderController._();

  // services
  final reminderService = ReminderService();

  // validator

  Future<Reminder> createReminder(String title, String description, double latitude, double longitude) async {
    CreateReminderDto request = CreateReminderDto(title, description, latitude, longitude);

    Reminder reminder = await reminderService.createReminder(request);
    return reminder;
  }

  Future<List<Reminder>> getAllReminders() async {
    List<Reminder> reminder = await reminderService.getAllReminders();
    return reminder;
  }

  Future<Reminder> updateReminder(String reminderId, String title, String description)  async {
    if (reminderId.isEmpty) {
      throw Exception("Reminder id is not provided");
    }
    UpdateReminderDto request = UpdateReminderDto(title, description, null);

    Reminder reminder = await reminderService.updateReminder(reminderId, request);
    return reminder;
  }

  Future<Reminder> updateReminderStatus(String reminderId, ReminderStatus status)  async {
    if (reminderId.isEmpty) {
      throw Exception("Reminder id is not provided");
    }
    UpdateReminderDto request = UpdateReminderDto(null, null, status);
    Reminder reminder = await reminderService.updateReminder(reminderId, request);
    return reminder;
  }

  Future<void> deleteReminder(String reminderId) async {
    if (reminderId.isEmpty) {
      throw Exception("Reminder id is not provided");
    }
    await reminderService.deleteReminder(reminderId);
  }

  Future<List<Reminder>> getRemindersWithStatus(ReminderStatus status) async {
    return await reminderService.getReminderWithStatus(status);
  }
}
