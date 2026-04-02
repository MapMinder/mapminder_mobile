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

  Reminder(
    this.reminderId,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.radius,
    this.status
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
    );
  }
}
