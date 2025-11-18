import 'dart:io';
import 'package:flutter/material.dart';
import '../services/recorder_service.dart';
import '../services/speech_service.dart';

/// Écran principal de l'enregistreur vocal.
///
/// Permet à l'utilisateur d'enregistrer sa voix et d'afficher la transcription.
class VoiceRecorderScreen extends StatefulWidget {
  const VoiceRecorderScreen({super.key});

  @override
  State<VoiceRecorderScreen> createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen> {
  final RecorderService _recorderService = RecorderService();
  final SpeechService _speechService = SpeechService();

  bool _isRecording = false;
  bool _isProcessing = false;
  String _transcribedText = "Appuyez et maintenez le bouton pour parler";

  @override
  void dispose() {
    _recorderService.dispose();
    super.dispose();
  }

  /// Démarre l'enregistrement audio et met à jour l'interface.
  Future<void> _startRecording() async {
    try {
      await _recorderService.startRecording();
      setState(() {
        _isRecording = true;
        _transcribedText = "Enregistrement en cours...";
      });
    } catch (e) {
      setState(() {
        _transcribedText = "Erreur: ${e.toString()}";
      });
    }
  }

  /// Arrête l'enregistrement, lance la transcription et met à jour l'interface.
  Future<void> _stopRecording() async {
    try {
      final path = await _recorderService.stopRecording();
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      if (path != null) {
        final File audioFile = File(path);
        final text = await _speechService.transcribeAudio(audioFile);

        if (mounted) {
          setState(() {
            _transcribedText = text;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _transcribedText = "Erreur lors de l'arrêt: $e";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistreur Vocal IA'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _isProcessing
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text("Transcription en cours..."),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Text(
                          _transcribedText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onLongPressStart: (_) => _startRecording(),
              onLongPressEnd: (_) => _stopRecording(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _isRecording ? 100 : 80,
                width: _isRecording ? 100 : 80,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.redAccent : Colors.blueAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_isRecording ? Colors.redAccent : Colors.blueAccent)
                              .withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: _isRecording ? 40 : 32,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isRecording ? 'Relâchez pour envoyer' : 'Maintenez pour parler',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
