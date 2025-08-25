import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.addressController != null) {
      _addressController = widget.addressController!;
      _isExternalController = true;
    } else {
      _addressController = TextEditingController();
    }
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _addressController.dispose();
    }
    super.dispose();
  }

  Future<void> _getAddressFromLatLng(LatLng pos) async {
    try {
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address =
        "${p.street ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''}, ${p.country ?? ''}"
            .replaceAll(RegExp(r'(, )+'), ', ') // убираем лишние запятые
            .trim()
            .replaceAll(RegExp(r'^,|,$'), '');   // убираем ведущие/конечные запятые

        setState(() {
          _addressController.text = address.isNotEmpty ? address : "Адрес не найден";
        });
      } else {
        setState(() => _addressController.text = "Адрес не найден");
      }
    } catch (e) {
      debugPrint("Ошибка геокодинга: $e");
      setState(() => _addressController.text = "Адрес не найден");
    }
  }

  /// Получаем координаты из введённого адреса
  Future<void> _getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final pos = LatLng(loc.latitude, loc.longitude);
        setState(() {
          _selectedPoint = pos;
        });
        _mapController?.animateCamera(CameraUpdate.newLatLng(pos));
      }
    } catch (e) {
      debugPrint("Не удалось найти адрес: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Адрес не найден")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
          widget.cameraPosition ?? DefaultMap._kUstKamenogorsk,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
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

        // 🔹 Встроенный текстбокс для поиска
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
                  hintText: "Введите адрес...",
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
      ],
    );
  }
}

