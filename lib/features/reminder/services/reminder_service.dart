import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/dto/create_reminder_dto.dart';
import 'package:mapminder_mobile/features/reminder/dto/update_reminder_dto.dart';
import 'package:mapminder_mobile/features/reminder/repository/reminder_repository.dart';

class ReminderService {
  static ReminderService?  _instance;

  factory ReminderService() {
    _instance ??= ReminderService._();
    return _instance!;
  }

  ReminderService._();
  final reminderRepository = ReminderRepository();

  Future<Reminder> createReminder(CreateReminderDto request) async {
    Reminder reminder = await reminderRepository.createReminder(request);
    return reminder;
  }

  Future<List<Reminder>> getAllReminders() async {
    List<Reminder> reminders = await reminderRepository.getAllReminders();
    return reminders;
  }

  Future<Reminder> updateReminder(String reminderId, UpdateReminderDto request) async {
    Reminder reminder = await reminderRepository.updateReminder(reminderId, request);
    return reminder;
  }
}
