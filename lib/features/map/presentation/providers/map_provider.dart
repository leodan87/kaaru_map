import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:kaaru_map/core/constants/mapbox_config.dart';

class MapProvider extends ChangeNotifier {
  MapboxMap? _mapboxController;
  geo.Position? _currentPosition;
  StreamSubscription<geo.Position>? _positionStream;
  geo.Position? _lastKnownPosition; // Para centrado rápido sin delay
  Timer? _gpsMonitor; // Monitoreo simple del GPS

  // Estado de los permisos y servicios de GPS
  bool _isGpsActive = false;
  bool _hasPermissions = false;
  bool _isLocationServiceEnabled = false;
  bool _wasGpsEnabled = false; // Para detectar reactivación

  // Getters para acceder al estado desde fuera de la clase
  bool get isGpsActive => _isGpsActive;
  bool get hasPermissions => _hasPermissions;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;
  geo.Position? get currentPosition => _currentPosition;

  // Conecta el mapa con el provider para controlarlo
  void setMapboxController(MapboxMap controller) {
    _mapboxController = controller;
    notifyListeners();
    
    // Auto-centrar si GPS está activo
    _autoCenter();
    
    // Iniciar monitoreo simple del GPS
    _startGpsMonitoring();
  }

  // Centra el mapa automáticamente al cargar la app
  Future<void> _autoCenter() async {
    try {
      final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      final permission = await geo.Geolocator.checkPermission();
      
      if (serviceEnabled && (permission == geo.LocationPermission.whileInUse || permission == geo.LocationPermission.always)) {
        final position = await geo.Geolocator.getCurrentPosition();
        final camera = CameraOptions(
          center: Point(coordinates: Position(position.longitude, position.latitude)),
          zoom: MapBoxConfig.defaultZoom,
        );
        _mapboxController!.setCamera(camera);
        _lastKnownPosition = position;
      }
    } catch (e) {
      // Silenciar errores en auto-centrado
    }
  }

  // Vigila si reactivas el GPS para auto-centrar
  void _startGpsMonitoring() {
    _gpsMonitor?.cancel();
    _gpsMonitor = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final isEnabled = await geo.Geolocator.isLocationServiceEnabled();
        
        // Si GPS se reactivó y tenemos mapa
        if (!_wasGpsEnabled && isEnabled && _mapboxController != null) {
          final permission = await geo.Geolocator.checkPermission();
          if (permission == geo.LocationPermission.whileInUse || permission == geo.LocationPermission.always) {
            developer.log('🚀 GPS reactivado - Auto-centrando', name: 'MapProvider');
            await _centerMapInstant();
          }
        }
        
        _wasGpsEnabled = isEnabled;
        _isLocationServiceEnabled = isEnabled;
      } catch (e) {
        // Silenciar errores
      }
    });
  }

  // Centra el mapa súper rápido usando ubicación guardada
  Future<void> _centerMapInstant() async {
    if (_mapboxController == null) return;

    try {
      geo.Position position;
      
      // Usar cache si existe (RÁPIDO)
      if (_lastKnownPosition != null) {
        position = _lastKnownPosition!;
      } else {
        // Solo si no hay cache
        position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 5),
        );
        _lastKnownPosition = position;
      }
      
      // Centrado instantáneo
      final camera = CameraOptions(
        center: Point(coordinates: Position(position.longitude, position.latitude)),
        zoom: MapBoxConfig.defaultZoom,
      );
      
      await _mapboxController!.setCamera(camera);
      _currentPosition = position;
      notifyListeners();
      
      // Actualizar cache en background
      _updateCacheInBackground();
      
    } catch (e) {
      developer.log('Error en centrado: $e', name: 'MapProvider');
    }
  }

  // Actualiza la ubicación guardada sin bloquear la app
  void _updateCacheInBackground() {
    geo.Geolocator.getCurrentPosition().then((position) {
      _lastKnownPosition = position;
      _currentPosition = position;
    }).catchError((_) {});
  }

  // Pide permisos de ubicación y centra automáticamente si acepta
  Future<bool> checkPermissions() async {
    try {
      final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      _isLocationServiceEnabled = serviceEnabled;

      if (!serviceEnabled) {
        _hasPermissions = false;
        _isGpsActive = false;
        notifyListeners();
        return false;
      }

      var permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied ||
            permission == geo.LocationPermission.deniedForever) {
          _hasPermissions = false;
          _isGpsActive = false;
          notifyListeners();
          return false;
        }
      }

      // Permisos concedidos - AUTO-CENTRAR
      _hasPermissions = true;
      _isGpsActive = serviceEnabled;
      notifyListeners();
      
      if (_mapboxController != null) {
        await _centerMapInstant();
      }
      
      return true;
    } catch (e) {
      _hasPermissions = false;
      _isGpsActive = false;
      notifyListeners();
      return false;
    }
  }

  // Verifica si ya tienes permisos de ubicación
  Future<bool> hasLocationPermission() async {
    return await checkPermissions();
  }

  // Se ejecuta cuando presionas el botón de ubicación
  Future<void> centerMapOnUser() async {
    if (_mapboxController == null) return;

    try {
      // Activar GPS si está desactivado
      final location = loc.Location();
      bool serviceEnabled = await location.serviceEnabled();
      
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      // Verificar permisos
      bool hasPermissions = await checkPermissions();
      if (!hasPermissions) return;

      // Centrar usando cache (RÁPIDO)
      await _centerMapInstant();
      
    } catch (e) {
      // Fallback con última posición conocida
      if (_lastKnownPosition != null) {
        final camera = CameraOptions(
          center: Point(coordinates: Position(_lastKnownPosition!.longitude, _lastKnownPosition!.latitude)),
          zoom: MapBoxConfig.defaultZoom,
        );
        await _mapboxController!.setCamera(camera);
      }
    }
  }

  /// Inicia el stream de ubicación con auto-centrado
  Future<void> startLocationUpdatesWithAutoCenter() async {
    _isGpsActive = true;
    await startLocationUpdates();
  }

  /// Inicia el stream para recibir actualizaciones de ubicación
  Future<void> startLocationUpdates() async {
    if (!await checkPermissions()) return;

    _positionStream?.cancel();

    const settings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream = geo.Geolocator.getPositionStream(locationSettings: settings).listen(
      (geo.Position position) {
        _currentPosition = position;
        _lastKnownPosition = position; // Mantener cache actualizado
        notifyListeners();

        if (_mapboxController != null) {
          if (_isGpsActive) {
            _updateMapLocationWithForceCenter(position);
            _isGpsActive = false;
          } else {
            _updateMapLocation(position);
          }
        }
      },
      onError: (error) {
        developer.log('Error en stream de ubicación: $error', name: 'MapProvider');
      },
    );
  }

  /// Actualiza mapa con centrado forzado
  void _updateMapLocationWithForceCenter(geo.Position position) {
    if (_mapboxController == null) return;

    final camera = CameraOptions(
      center: Point(coordinates: Position(position.longitude, position.latitude)),
      zoom: MapBoxConfig.defaultZoom,
    );

    _mapboxController!.flyTo(camera, MapAnimationOptions(duration: 800));
  }

  /// Actualiza ubicación normal
  void _updateMapLocation(geo.Position position) {
    if (_mapboxController == null) return;

    final camera = CameraOptions(
      center: Point(coordinates: Position(position.longitude, position.latitude)),
    );

    _mapboxController!.easeTo(camera, MapAnimationOptions(duration: 1000));
  }

  /// Detiene actualizaciones de ubicación
  void stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  /// Limpia recursos al eliminar el Provider
  @override
  void dispose() {
    stopLocationUpdates();
    _gpsMonitor?.cancel();
    super.dispose();
  }
}