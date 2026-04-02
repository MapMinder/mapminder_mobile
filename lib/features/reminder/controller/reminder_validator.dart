import 'package:mapminder_mobile/features/reminder/dto/create_reminder_dto.dart';

class ReminderValidator {
  static ReminderValidator? _instance;

  factory ReminderValidator() {
    _instance ??= ReminderValidator._();
    return _instance!;
  }

  ReminderValidator._();

  void validateCreateReminderDto(CreateReminderDto reminder) {
    if (reminder.title.isEmpty) {
      throw Exception("Title is empty");
    }

    if (reminder.title.length > 65) {
      throw Exception("Title is too long");
    }

    if (reminder.description.isEmpty) {
      throw Exception("Description is empty");
    }

    if (reminder.description.length > 200) {
      throw Exception("Description is too long");
    }
  }
}

