import 'package:flutter/material.dart';
import 'screens/voice_recorder_screen.dart';

/// Point d'entrée de l'application.
void main() {
  runApp(const VoiceApp());
}

/// Widget racine de l'application.
///
/// Configure le thème et la page d'accueil de l'application.
class VoiceApp extends StatelessWidget {
  const VoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enregistreur Vocal IA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const VoiceRecorderScreen(),
    );
  }
}
