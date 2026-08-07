import 'package:timeago/timeago.dart' as timeago;

enum ReminderStatus {
  active,
  paused,
  completed,
}

class Reminder {
  String reminderId;
  String title;
  String description;
  double latitude;
  double longitude;
  num radius;
  ReminderStatus status;
  String locationName;
  String createdAt;
  String? completedAt;

  Reminder(
    this.reminderId,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.radius,
    this.status,
    this.locationName,
    this.createdAt,
    this.completedAt,
  );

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      json['reminder_id'],
      json['title'],
      json['description'],
      json['latitude'],
      json['longitude'],
      json['radius'],
      ReminderStatus.values.byName(json['status']),
      json['location_name'],
      json['created_at'],
      json['completed_at'],
    );
  }

  String getTimeBeforeCreationTimeAgo() {
    DateTime createdAtDateTime = DateTime.parse(createdAt);
    String result = timeago.format(createdAtDateTime);
    return result;
  }

  String getCompletedTimeBeforeCreationTimeAgo() {
    DateTime completedDateTime = DateTime.parse(completedAt!);
    String result = timeago.format(completedDateTime);
    return result;
  }

  String getLocationName() {
    return locationName;
  }
}
