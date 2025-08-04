import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:kaaru_map/core/router/app_router.dart';
import 'package:kaaru_map/core/constants/mapbox_config.dart';

// Función principal que inicia la aplicación
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(MapBoxConfig.accessToken);
  runApp(const MyApp());
}

// Clase principal de la aplicación que configura el tema y rutas
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Construye la aplicación con configuración de tema y navegación
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kaaru Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        fontFamily: 'Roboto',
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
