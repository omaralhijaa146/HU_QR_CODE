class ClassLocationModel {
  double latitude = 0;
  double longitude = 0;
  int range = 0;

  ClassLocationModel({
    required this.latitude,
    required this.longitude,
    required this.range
  });

  ClassLocationModel.fromJson(Map<String, dynamic>json){
    latitude = json['latitude'];
    longitude = json['longitude'];
    range = json['range'];
  }

  Map<String, dynamic> toMap() =>
      {
        'latitude': latitude,
        'longitude': longitude,
        'range': range,
      };
}