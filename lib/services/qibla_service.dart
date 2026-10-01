import 'dart:math';

class CityLocation {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  const CityLocation({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}

class QiblaService {
  // Sacred Kaaba coordinates in Mecca, Saudi Arabia
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  /// Calculate Qibla angle from North in degrees (0 to 360)
  static double calculateQiblaDirection(double lat, double lon) {
    final double latRad = lat * (pi / 180.0);
    final double lonRad = lon * (pi / 180.0);
    final double kaabaLatRad = kaabaLatitude * (pi / 180.0);
    final double kaabaLonRad = kaabaLongitude * (pi / 180.0);

    final double deltaLon = kaabaLonRad - lonRad;

    final double y = sin(deltaLon);
    final double x = cos(latRad) * tan(kaabaLatRad) - sin(latRad) * cos(deltaLon);

    double qiblaAngle = atan2(y, x) * (180.0 / pi);
    return (qiblaAngle + 360.0) % 360.0;
  }

  /// Calculate straight-line distance to Kaaba in kilometers (Haversine formula)
  static double calculateDistanceKm(double lat, double lon) {
    const double earthRadiusKm = 6371.0;
    final double dLat = (kaabaLatitude - lat) * (pi / 180.0);
    final double dLon = (kaabaLongitude - lon) * (pi / 180.0);
    final double lat1 = lat * (pi / 180.0);
    final double lat2 = kaabaLatitude * (pi / 180.0);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// List of major cities around the world
  static const List<CityLocation> popularCities = [
    // Türkiye
    CityLocation(name: "İstanbul", country: "Türkiye", latitude: 41.0082, longitude: 28.9784),
    CityLocation(name: "Ankara", country: "Türkiye", latitude: 39.9334, longitude: 32.8597),
    CityLocation(name: "İzmir", country: "Türkiye", latitude: 38.4237, longitude: 27.1428),
    CityLocation(name: "Bursa", country: "Türkiye", latitude: 40.1885, longitude: 29.0610),
    CityLocation(name: "Konya", country: "Türkiye", latitude: 37.8746, longitude: 32.4932),
    CityLocation(name: "Antalya", country: "Türkiye", latitude: 36.8969, longitude: 30.7133),
    CityLocation(name: "Diyarbakır", country: "Türkiye", latitude: 37.9144, longitude: 40.2306),
    CityLocation(name: "Trabzon", country: "Türkiye", latitude: 41.0027, longitude: 39.7168),

    // Middle East & Sacred
    CityLocation(name: "Mekke", country: "Suudi Arabistan", latitude: 21.4225, longitude: 39.8262),
    CityLocation(name: "Medine", country: "Suudi Arabistan", latitude: 24.4672, longitude: 39.6111),
    CityLocation(name: "Kudüs (Al-Quds)", country: "Filistin", latitude: 31.7683, longitude: 35.2137),
    CityLocation(name: "Kahire", country: "Mısır", latitude: 30.0444, longitude: 31.2357),
    CityLocation(name: "Bağdat", country: "Irak", latitude: 33.3152, longitude: 44.3661),
    CityLocation(name: "Şam", country: "Suriye", latitude: 33.5138, longitude: 36.2765),
    CityLocation(name: "Tahran", country: "İran", latitude: 35.6892, longitude: 51.3890),
    CityLocation(name: "Dubai", country: "BAE", latitude: 25.2048, longitude: 55.2708),
    CityLocation(name: "Doha", country: "Katar", latitude: 25.2854, longitude: 51.5310),

    // Europe
    CityLocation(name: "Londra", country: "İngiltere", latitude: 51.5074, longitude: -0.1278),
    CityLocation(name: "Berlin", country: "Almanya", latitude: 52.5200, longitude: 13.4050),
    CityLocation(name: "Paris", country: "Fransa", latitude: 48.8566, longitude: 2.3522),
    CityLocation(name: "Roma", country: "İtalya", latitude: 41.9028, longitude: 12.4964),
    CityLocation(name: "Saraybosna", country: "Bosna Hersek", latitude: 43.8563, longitude: 18.4131),
    CityLocation(name: "Amsterdam", country: "Hollanda", latitude: 52.3676, longitude: 4.9041),
    CityLocation(name: "Moskova", country: "Rusya", latitude: 55.7558, longitude: 37.6173),

    // Asia & Americas
    CityLocation(name: "Cakarta", country: "Endonezya", latitude: -6.2088, longitude: 106.8456),
    CityLocation(name: "Kuala Lumpur", country: "Malezya", latitude: 3.1390, longitude: 101.6869),
    CityLocation(name: "İslamabad", country: "Pakistan", latitude: 33.6844, longitude: 73.0479),
    CityLocation(name: "Taşkent", country: "Özbekistan", latitude: 41.2995, longitude: 69.2401),
    CityLocation(name: "Bakü", country: "Azerbaycan", latitude: 40.4093, longitude: 49.8671),
    CityLocation(name: "New York", country: "ABD", latitude: 40.7128, longitude: -74.0060),
    CityLocation(name: "Toronto", country: "Kanada", latitude: 43.6532, longitude: -79.3832),
  ];

  static CityLocation get defaultCity => popularCities[0]; // İstanbul default
}
