# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- 🎯 **Automatic location centering** - Map centers instantly when location permissions are granted
- ⚡ **GPS reactivation detection** - Automatic centering when GPS service is reactivated
- 💾 **Smart location caching** - Uses cached position for instant map centering without delays
- 🔄 **Real-time GPS monitoring** - Background GPS status monitoring with Timer.periodic
- 🎨 **Clean Mapbox integration** - Seamless Mapbox Maps Flutter integration
- 📱 **Provider state management** - Efficient state handling using Provider pattern
- 🎛️ **Customizable map settings** - Configurable zoom levels, fallback locations, and map styles
- 🎨 **Custom UI elements** - Floating action button for manual location centering
- 🔒 **Automatic permission handling** - Streamlined location permission management
- 🌍 **Fallback location support** - Default to configurable location when GPS unavailable
- 🎯 **Location puck display** - Visual user location indicator with accuracy ring
- 🔧 **Disabled UI elements** - Clean map appearance without Mapbox logo and attribution
- 📍 **Background location updates** - Keeps location cache fresh without blocking UI

### Technical Features
- MapboxMap integration with proper controller lifecycle
- Geolocator package for cross-platform location services
- Location package for additional GPS service management
- GoRouter for navigation management
- Custom Provider implementation for map state
- Timer-based GPS monitoring for reactivation detection
- Cached position strategy for instant centering
- Clean architecture with separated concerns

### Dependencies
- `mapbox_maps_flutter: ^1.0.0` - Mapbox Maps integration
- `geolocator: ^10.1.0` - Location services
- `location: ^5.0.3` - Additional location management
- `provider: ^6.1.1` - State management
- `go_router: ^13.2.0` - Navigation

---

## Future Releases

### Planned Features
- [ ] Multiple map style options
- [ ] Custom markers and annotations
- [ ] Route planning and navigation
- [ ] Offline map support
- [ ] Custom location search
- [ ] Map clustering for multiple points
- [ ] Export to pub.dev