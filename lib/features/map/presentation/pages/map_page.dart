import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../widgets/map_container.dart';
import 'package:kaaru_map/core/constants/app_colors.dart';

// Página principal que configura el provider del mapa
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapProvider(),
      child: const MapPageView(),
    );
  }
}

// Widget que contiene la interfaz visual del mapa
class MapPageView extends StatefulWidget {
  const MapPageView({super.key});

  @override
  State<MapPageView> createState() => _MapPageViewState();
}

// Estado que maneja la interfaz del mapa y el botón
class _MapPageViewState extends State<MapPageView> {
  // Construye la pantalla con el mapa y el botón flotante
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        backgroundColor: AppColors.turquesa,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Mapa principal
          const MapContainer(),

          // Botón para centrar el mapa
          Positioned(
            bottom: 50,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                final mapProvider = context.read<MapProvider>();
                mapProvider.centerMapOnUser();
              },
              mini: true,
              backgroundColor: AppColors.turquesa,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
