class UpdateReminderDto {
  String title;
  String description;

  UpdateReminderDto(
    this.title,
    this.description,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "title": title,
      "description": description
    };
  }
}

