import 'package:flutter/material.dart';
import 'package:pdf_viewer_app/services/voice_reader_service.dart';

/// Widget for voice reader controls
class VoiceReaderControls extends StatefulWidget {
  final String textToRead;
  final VoiceReaderService voiceService;
  final Function(bool isPlaying)? onPlayingChanged;

  const VoiceReaderControls({
    super.key,
    required this.textToRead,
    required this.voiceService,
    this.onPlayingChanged,
  });

  @override
  State<VoiceReaderControls> createState() => _VoiceReaderControlsState();
}

class _VoiceReaderControlsState extends State<VoiceReaderControls> {
  late VoiceReaderService _voiceService;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _voiceService = widget.voiceService;
  }

  void _togglePlayStop() async {
    try {
      if (!_isPlaying) {
        // Start playing
        await _voiceService.speak(widget.textToRead);
        setState(() {
          _isPlaying = true;
        });
        widget.onPlayingChanged?.call(true);
      } else {
        // Stop
        await _voiceService.stop();
        setState(() {
          _isPlaying = false;
        });
        widget.onPlayingChanged?.call(false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Voice Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Speech Rate
              Text(
                'Speech Rate: ${(_voiceService.speechRate * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _voiceService.speechRate,
                onChanged: (value) async {
                  await _voiceService.setSpeechRate(value);
                  setState(() {});
                },
                min: 0.0,
                max: 2.0,
                divisions: 20,
              ),
              const SizedBox(height: 16),

              // Pitch
              Text(
                'Pitch: ${_voiceService.pitch.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _voiceService.pitch,
                onChanged: (value) async {
                  await _voiceService.setPitch(value);
                  setState(() {});
                },
                min: 0.5,
                max: 2.0,
                divisions: 30,
              ),
              const SizedBox(height: 16),

              // Volume
              Text(
                'Volume: ${(_voiceService.volume * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _voiceService.volume,
                onChanged: (value) async {
                  await _voiceService.setVolume(value);
                  setState(() {});
                },
                min: 0.0,
                max: 1.0,
                divisions: 10,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Play/Stop Button
              FloatingActionButton.small(
                onPressed: _togglePlayStop,
                tooltip: _isPlaying ? 'Stop' : 'Play Voice',
                child: Icon(
                  _isPlaying ? Icons.stop : Icons.play_arrow,
                ),
              ),

              // Settings Button
              FloatingActionButton.small(
                onPressed: _showVoiceSettings,
                tooltip: 'Voice Settings',
                child: const Icon(Icons.settings_voice),
              ),
            ],
          ),
          if (_isPlaying)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mic,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Playing...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _voiceService.stop();
    super.dispose();
  }
}
