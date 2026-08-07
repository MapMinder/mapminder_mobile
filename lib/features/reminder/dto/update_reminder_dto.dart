import 'package:mapminder_mobile/features/reminder/domain/reminder.dart';

class UpdateReminderDto {
  String? title;
  String? description;
  ReminderStatus? status;

  UpdateReminderDto(
    this.title,
    this.description,
    this.status,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (title != null) map["title"] = title;
    if (description != null) map["description"] = description;
    if (status != null) map["status"] = status!.name;
    return map;
  }
}

