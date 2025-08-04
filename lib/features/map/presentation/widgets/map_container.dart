import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../providers/map_provider.dart';
import 'package:kaaru_map/core/constants/mapbox_config.dart';

/// Widget contenedor del mapa Mapbox
class MapContainer extends StatefulWidget {
  const MapContainer({super.key});

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  MapboxMap? _mapboxMap;
  StreamSubscription<geo.ServiceStatus>? _gpsStatusSubscription;

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey("mapWidget"),
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(MapBoxConfig.fallbackLongitude, MapBoxConfig.fallbackLatitude)),
        zoom: MapBoxConfig.defaultZoom,
      ),
      styleUri: MapboxStyles.MAPBOX_STREETS,
      textureView: true,
      onMapCreated: _onMapCreated,
    );
  }

  // Se ejecuta cuando el mapa ya está listo para usarse
  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    final mapProvider = context.read<MapProvider>();
    mapProvider.setMapboxController(mapboxMap);

    // Deshabilitar elementos visuales innecesarios
    try {
      await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
      await mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
      await mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
      await mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
    } catch (e) {
      developer.log('Error deshabilitando elementos UI: $e', name: 'MapContainer');
    }

    // Inicializar ubicación del usuario
    await _initializePuckAlwaysActive(mapboxMap);
    _startGpsStatusListener();
  }

  // Configura el puntito azul que muestra tu ubicación
  Future<void> _initializePuckAlwaysActive(MapboxMap mapboxMap) async {
    try {
      await mapboxMap.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          showAccuracyRing: false,
          puckBearingEnabled: false,
        ),
      );
    } catch (e) {
      developer.log('Error inicializando ubicación: $e', name: 'MapContainer');
    }
  }

  // Detecta automáticamente si enciendes/apagas el GPS
  void _startGpsStatusListener() {
    _gpsStatusSubscription = geo.Geolocator.getServiceStatusStream().listen((status) {
      final gpsOn = status == geo.ServiceStatus.enabled;
      _updateAccuracyRingBasedOnGPS(gpsOn);
    });
    
    _checkInitialGpsState();
  }

  // Revisa si el GPS ya está encendido al iniciar
  void _checkInitialGpsState() async {
    try {
      final isEnabled = await geo.Geolocator.isLocationServiceEnabled();
      _updateAccuracyRingBasedOnGPS(isEnabled);
    } catch (e) {
      developer.log('Error verificando GPS inicial: $e', name: 'MapContainer');
    }
  }

  // Muestra/oculta el círculo azul según si GPS está encendido
  void _updateAccuracyRingBasedOnGPS(bool gpsOn) async {
    if (_mapboxMap == null) return;

    try {
      await _mapboxMap!.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          showAccuracyRing: gpsOn,
          puckBearingEnabled: gpsOn,
        ),
      );
    } catch (e) {
      developer.log('Error actualizando anillo: $e', name: 'MapContainer');
    }
  }

  @override
  void dispose() {
    _gpsStatusSubscription?.cancel();
    super.dispose();
  }
}