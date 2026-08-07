class CreateReminderDto {
  String title;
  String description;
  double latitude;
  double longitude;
  String locationName;

  CreateReminderDto(
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.locationName,
  );

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "title": title,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "location_name": locationName
    };
  }
}
