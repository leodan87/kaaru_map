import 'package:go_router/go_router.dart';
import 'package:kaaru_map/features/map/presentation/pages/map_page.dart';

// Configuración de navegación de la aplicación
class AppRouter {
  // Define todas las rutas/pantallas disponibles en la app
  static final router = GoRouter(
    initialLocation: '/', // Pantalla inicial al abrir la app
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MapPage()),
    ],
  );
}
