class UserPositionModel {
  final double latitude;
  final double longitude;
  final String cityName;
  const UserPositionModel(this.latitude, this.longitude, this.cityName);

  UserPositionModel.fromJson(Map<String, dynamic> json)
      : cityName = json['name'],
        latitude = json['lat'],
        longitude = json['lon'];
}
