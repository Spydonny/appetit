import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class DefaultMap extends StatefulWidget {
  const DefaultMap({
    super.key,
    this.cameraPosition,
    this.selectable = false,
    this.addressController,
  });

  final CameraPosition? cameraPosition;
  final bool selectable;
  final TextEditingController? addressController;

  static const CameraPosition _kUstKamenogorsk = CameraPosition(
    target: LatLng(49.9483, 82.6275),
    zoom: 12.4746,
  );

  @override
  State<DefaultMap> createState() => _DefaultMapState();
}

class _DefaultMapState extends State<DefaultMap> {
  GoogleMapController? _mapController;
  LatLng? _selectedPoint;
  late final TextEditingController _addressController;
  bool _isExternalController = false;

  final String _googleApiKey = "⚠️ ВСТАВЬ_СВОЙ_API_KEY";

  @override
  void initState() {
    super.initState();
    if (widget.addressController != null) {
      _addressController = widget.addressController!;
      _isExternalController = true;
    } else {
      _addressController = TextEditingController();
    }

    _checkPermissionAndInit();
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _addressController.dispose();
    }
    super.dispose();
  }

  /// 🔹 Проверяем и запрашиваем доступ к геолокации
  Future<void> _checkPermissionAndInit() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr("map.permission_denied_forever"))),
        );
      }
      return;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // 👉 можно сразу показать юзера при старте
      await _goToUserLocation();
    }
  }

  /// 🔹 Получаем локализованный адрес по координатам
  Future<void> _getAddressFromLatLng(LatLng pos) async {
    try {
      final lang = context.locale.languageCode;
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json"
            "?latlng=${pos.latitude},${pos.longitude}"
            "&language=$lang"
            "&key=$_googleApiKey",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK" && data["results"].isNotEmpty) {
          final address = data["results"][0]["formatted_address"];
          setState(() {
            _addressController.text = address;
          });
        } else {
          setState(() => _addressController.text = tr("map.address_not_found"));
        }
      } else {
        setState(() => _addressController.text = tr("map.address_not_found"));
      }
    } catch (e) {
      debugPrint("Ошибка геокодинга: $e");
      setState(() => _addressController.text = tr("map.address_not_found"));
    }
  }

  /// 🔹 Получаем координаты из адреса
  Future<void> _getLatLngFromAddress(String address) async {
    try {
      final lang = context.locale.languageCode;
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json"
            "?address=${Uri.encodeComponent(address)}"
            "&language=$lang"
            "&key=$_googleApiKey",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK" && data["results"].isNotEmpty) {
          final result = data["results"][0];
          final location = result["geometry"]["location"];
          final pos = LatLng(location["lat"], location["lng"]);
          final formattedAddress = result["formatted_address"];

          setState(() {
            _selectedPoint = pos;
            _addressController.text = formattedAddress;
          });

          _mapController?.animateCamera(CameraUpdate.newLatLng(pos));
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr("map.address_not_found"))),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Не удалось найти адрес: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr("map.address_not_found"))),
        );
      }
    }
  }

  /// 🔹 Определяем позицию пользователя
  Future<void> _goToUserLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(pos.latitude, pos.longitude);

      setState(() => _selectedPoint = latLng);

      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));

      await _getAddressFromLatLng(latLng);
    } catch (e) {
      debugPrint("Ошибка получения геопозиции: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:
          widget.cameraPosition ?? DefaultMap._kUstKamenogorsk,
          myLocationEnabled: true,
          myLocationButtonEnabled: false, // ❌ отключаем дефолтную кнопку
          onMapCreated: (controller) => _mapController = controller,
          markers: _selectedPoint != null
              ? {
            Marker(
              markerId: const MarkerId("selected"),
              position: _selectedPoint!,
            )
          }
              : {},
          onTap: widget.selectable
              ? (LatLng pos) async {
            setState(() {
              _selectedPoint = pos;
            });
            await _getAddressFromLatLng(pos);
          }
              : null,
        ),

        // 🔹 Поисковый TextField
        if (widget.selectable)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  hintText: tr("map.enter_address"),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () =>
                        _getLatLngFromAddress(_addressController.text),
                  ),
                ),
                onSubmitted: _getLatLngFromAddress,
              ),
            ),
          ),

        // 🔹 Кнопка перехода к геопозиции юзера
        Positioned(
          bottom: 20,
          left: 20,
          child: FloatingActionButton(
            onPressed: _goToUserLocation,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ),
      ],
    );
  }
}


