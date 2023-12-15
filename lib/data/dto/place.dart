class Place {
  String fullAddress;
  double latitude;
  double longitude;

  Place(this.fullAddress, this.latitude, this.longitude);

  @override
  String toString() {
    return 'Place{fullAddress: $fullAddress, latitude: $latitude, longitude: $longitude}';
  }
}
