# Kaaru Map 🗺️

A Flutter map library with automatic location centering using Mapbox. Features instant GPS detection, cached positioning, and seamless user experience.

## ✨ Features

- **🎯 Automatic location centering** - Centers map instantly when permissions are granted
- **⚡ GPS reactivation detection** - Auto-centers when GPS is turned back on
- **💾 Smart location caching** - Uses cached position for instant centering
- **🔄 Real-time GPS monitoring** - Background monitoring with minimal battery impact
- **🎨 Clean Mapbox integration** - Customizable map styles and settings
- **📱 Provider state management** - Efficient state handling with Provider pattern

## 🚀 Quick Setup

### 1. Get Mapbox Access Token

1. Go to [mapbox.com](https://mapbox.com) and create a free account
2. Navigate to your [Access Tokens](https://account.mapbox.com/access-tokens/)
3. Copy your default public token (starts with `pk.`)

### 2. Configure Token

Replace the placeholder in `lib/core/constants/mapbox_config.dart`:

```dart
class MapBoxConfig {
  static const String accessToken = 'YOUR_ACTUAL_MAPBOX_TOKEN_HERE';
  // ... rest of config
}
```

### 3. Add Dependencies

The library uses these packages (already included):

```yaml
dependencies:
  flutter:
    sdk: flutter
  mapbox_maps_flutter: ^1.0.0
  geolocator: ^10.1.0
  location: ^5.0.3
  provider: ^6.1.1
  go_router: ^13.2.0
```

### 4. Use in Your App

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaaru_map/features/map/presentation/pages/map_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapPage(), // Add the map page
    );
  }
}
```

## 📖 Usage Examples

### Basic Map Implementation

```dart
import 'package:kaaru_map/features/map/presentation/pages/map_page.dart';

// Simple map page
class MyMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MapPage();
  }
}
```

### Custom Integration with Provider

```dart
import 'package:provider/provider.dart';
import 'package:kaaru_map/features/map/presentation/providers/map_provider.dart';

class CustomMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapProvider(),
      child: Consumer<MapProvider>(
        builder: (context, mapProvider, child) {
          return Scaffold(
            body: MapContainer(),
            floatingActionButton: FloatingActionButton(
              onPressed: () => mapProvider.centerMapOnUser(),
              child: Icon(Icons.my_location),
            ),
          );
        },
      ),
    );
  }
}
```

## ⚙️ Configuration

### Customize Map Settings

Edit `lib/core/constants/mapbox_config.dart`:

```dart
class MapBoxConfig {
  static const String accessToken = 'your_token_here';
  static const String mapStyle = 'mapbox://styles/mapbox/streets-v12';
  static const double defaultZoom = 16.0;
  static const double minZoom = 1.0;
  static const double maxZoom = 22.0;
  
  // Fallback location (Bogotá, Colombia)
  static const double fallbackLatitude = 4.6097;
  static const double fallbackLongitude = -74.0817;
}
```

### Customize Colors

Edit `lib/core/constants/app_colors.dart`:

```dart
class AppColors {
  static const Color turquesa = Color(0xFF20B2AA);
  // Add your custom colors
}
```

## 🔧 Available Methods

### MapProvider Methods

```dart
// Center map on user location
await mapProvider.centerMapOnUser();

// Check location permissions
bool hasPermissions = await mapProvider.hasLocationPermission();

// Manual permission check
bool granted = await mapProvider.checkPermissions();

// Stop location updates
mapProvider.stopLocationUpdates();
```

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Color definitions
│   │   └── mapbox_config.dart         # Mapbox configuration
│   └── router/
│       └── app_router.dart            # App navigation
└── features/map/
    └── presentation/
        ├── pages/
        │   └── map_page.dart          # Main map screen
        ├── widgets/
        │   └── map_container.dart     # Map widget container
        └── providers/
            └── map_provider.dart      # Map state management
```

## 🔒 Permissions

The library automatically handles location permissions, but make sure to add them to your platform configurations:

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show your position on the map</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access to show your position on the map</string>
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Mapbox](https://mapbox.com) for the amazing mapping platform
- Flutter team for the excellent framework
- All contributors who help improve this library

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/leodan87/kaaru_map/issues) page
2. Create a new issue with detailed description
3. Include your Flutter version and platform details

---

Made with ❤️ for the Flutter community