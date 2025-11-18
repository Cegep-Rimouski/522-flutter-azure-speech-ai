import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Service gérant l'enregistrement audio.
///
/// Utilise le package `record` pour capturer l'audio du microphone.
class RecorderService {
  final AudioRecorder _audioRecorder = AudioRecorder();

  /// Démarre l'enregistrement audio.
  ///
  /// Vérifie d'abord les permissions. Si accordées, configure l'enregistreur
  /// pour produire un fichier WAV compatible avec Azure Speech-to-Text
  /// (PCM 16kHz, 16-bit, mono).
  ///
  /// Lève une exception si la permission est refusée.
  Future<void> startRecording() async {
    final bool hasPermission = await _audioRecorder.hasPermission();

    if (hasPermission) {
      final Directory tempDir = await getTemporaryDirectory();
      final String path = '${tempDir.path}/voice.wav';

      // Configuration spécifique pour Azure Speech-to-Text
      // Azure demande souvent du WAV PCM 16kHz 16-bit mono
      const config = RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        bitRate: 16000,
        numChannels: 1,
      );

      // S'assurer qu'on ne s'enregistre pas par dessus une session existante sans l'arrêter proprement
      if (await _audioRecorder.isRecording()) {
        await _audioRecorder.stop();
      }

      await _audioRecorder.start(config, path: path);
    } else {
      throw Exception('Permission d\'enregistrement refusée');
    }
  }

  /// Arrête l'enregistrement en cours.
  ///
  /// Retourne le chemin du fichier audio enregistré, ou `null` si aucun
  /// enregistrement n'était en cours.
  Future<String?> stopRecording() async {
    if (!await _audioRecorder.isRecording()) {
      return null;
    }
    return await _audioRecorder.stop();
  }

  /// Libère les ressources utilisées par l'enregistreur.
  void dispose() {
    _audioRecorder.dispose();
  }
}
