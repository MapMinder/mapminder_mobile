class CreateReminderDto {
  String title;
  String description;
  double latitude;
  double longitude;

  CreateReminderDto(
    this.title,
    this.description,
    this.latitude,
    this.longitude,
  );

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
