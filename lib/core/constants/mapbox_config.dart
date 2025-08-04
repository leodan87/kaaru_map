class MapBoxConfig {
  // REPLACE WITH YOUR MAPBOX TOKEN
  // Get your free token at: https://account.mapbox.com/access-tokens/
  static const String accessToken = 'PUT_YOUR_MAPBOX_TOKEN_HERE';

  // Estilo de mapa
  static const String mapStyle = 'mapbox://styles/mapbox/streets-v12';

  // Configuraciones por defecto
  static const double defaultZoom = 16.0;
  static const double minZoom = 1.0;
  static const double maxZoom = 22.0;

  // Ubicación por defecto (fallback si no hay última ubicación conocida)
  // Bogotá, Colombia - Centro de la ciudad
  static const double fallbackLatitude = 4.6097;
  static const double fallbackLongitude = -74.0817;
}
