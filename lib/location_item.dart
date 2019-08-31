class LocationItem {
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final int id;

  LocationItem({this.name, this.type, this.latitude, this.longitude, this.id});

  factory LocationItem.fromJson(Map json) {
    return LocationItem(
        name: json['name'],
        type: json['type'],
        latitude: double.parse(json['latitude']),
        longitude: double.parse(json['longitude']),
        id: int.parse(json['id']));
  }
}
