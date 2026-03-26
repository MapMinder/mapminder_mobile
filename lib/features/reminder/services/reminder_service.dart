import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';
import 'package:mapminder_mobile/features/reminder/dto/create_reminder_dto.dart';
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
}
