import 'dart:io';

/// Service gérant la communication avec l'API Azure Speech-to-Text.
class SpeechService {
  /// Transcrit un fichier audio en texte via l'API Azure.
  ///
  /// Prend en entrée un [File] audio (format WAV recommandé).
  /// Retourne le texte transcrit ou un message d'erreur.
  Future<String> transcribeAudio(File audioFile) async {
    // TODO: Implémentez la transcription avec l'API Azure.
    throw UnimplementedError();
  }
}
