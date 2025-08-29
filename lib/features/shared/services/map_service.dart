import '../data/maps/maps.dart';

class MapService {
  final MapRepo _repo;

  MapService({required MapRepo repo}) : _repo = repo;

  /// Forward geocoding: текст -> координаты
  Future<GeocodeResponse> forwardGeocode(String address) async {
    final req = ForwardGeocodeRequest(address: address);
    final response = await _repo.forwardGeocode(req);
    if (response.status != "OK") {
      throw Exception("Forward geocode error: ${response.errorMessage}");
    }
    return response;
  }

  /// Reverse geocoding: координаты -> адрес
  Future<GeocodeResponse> reverseGeocode(double lat, double lng) async {
    final req = ReverseGeocodeRequest(lat: lat, lng: lng);
    final response = await _repo.reverseGeocode(req);
    if (response.status != "OK") {
      throw Exception("Reverse geocode error: ${response.errorMessage}");
    }
    return response;
  }

  /// Быстрая версия reverse (с фильтрацией)
  Future<GeocodeResponse> quickReverse({
    required double lat,
    required double lng,
    String language = "ru",
    bool precise = true,
  }) async {
    final response = await _repo.quickReverse(
      lat: lat,
      lng: lng,
      language: language,
      precise: precise,
    );
    if (response.status != "OK") {
      throw Exception("Quick reverse error: ${response.errorMessage}");
    }
    return response;
  }

  /// Валидация адреса (на случай падения геокодинга)
  Future<AddressValidationResponse> validateAddress(OrderAddressData data) async {
    final response = await _repo.validateAddress(data);
    if (!response.isValid) {
      throw Exception("Address validation failed: ${response.components}");
    }
    return response;
  }
}

