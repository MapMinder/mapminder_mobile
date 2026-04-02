import 'package:mapminder_mobile/features/reminder/controller/reminder_validator.dart';
import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/dto/create_reminder_dto.dart';
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
  final validator = ReminderValidator();

  Future<Reminder> createReminder(String title, String description, double latitude, double longitude) async {
    CreateReminderDto request = CreateReminderDto(title, description, latitude, longitude);

    validator.validateCreateReminderDto(request);

   Reminder reminder = await reminderService.createReminder(request);
    return reminder;
  }
}
