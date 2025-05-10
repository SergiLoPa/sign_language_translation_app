import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String _currentTranslation = '–';
  List<String> _history = [];
  bool _isTranslating = true;

  // TTS
  late FlutterTts _tts;
  List<Map<String, String>> _voices = []; // ahora con String,String
  Map<String, String>? _selectedVoice; // voz seleccionada

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _tts.awaitSpeakCompletion(true);
    _tts.setStartHandler(() => print("▶️ TTS start"));
    _tts.setCompletionHandler(() => print("✅ TTS done"));
    _tts.setErrorHandler((msg) => print("❌ TTS error: $msg"));
    _initTts();

    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      _simulateTranslation();
    });
  }

  Future<void> _initTts() async {
    // Obtén las voces y conviértelas a Map<String,String>
    final rawVoices = await _tts.getVoices; // List<dynamic>
    if (rawVoices != null) {
      _voices = rawVoices.map<Map<String, String>>((v) {
        final map = v as Map;
        return {
          'name': map['name'] as String,
          'locale': map['locale'] as String,
        };
      }).toList();
    }

    if (_voices.isNotEmpty) {
      _selectedVoice = _voices.first;
      await _tts.setVoice(_selectedVoice!);
      await _tts.setLanguage(_selectedVoice!['locale']!);
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      setState(() {});
    }
  }

  Future<void> _speak(String text) async {
    await _tts.stop();
    if (_selectedVoice != null) {
      await _tts.setVoice(_selectedVoice!);
      await _tts.setLanguage(_selectedVoice!['locale']!);
    }
    await _tts.speak(text);
  }

  void _togglePause() => setState(() => _isTranslating = !_isTranslating);

  void _resetHistory() {
    setState(() {
      _history.clear();
      _currentTranslation = '–';
      _isTranslating = true;
    });
  }

  void _simulateTranslation() {
    if (!_isTranslating) return;
    setState(() {
      _currentTranslation = 'Hola';
      _history.insert(0, _currentTranslation);
    });
    _speak(_currentTranslation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traducción en Tiempo Real'),
        actions: [
          IconButton(
            icon: Icon(_isTranslating ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePause,
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetHistory),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selector de voz
              if (_voices.isNotEmpty && _selectedVoice != null) ...[
                Text('Voz:', style: TextStyle(fontSize: 16)),
                DropdownButton<Map<String, String>>(
                  value: _selectedVoice!,
                  isExpanded: true,
                  items: _voices.map<DropdownMenuItem<Map<String, String>>>((
                    voice,
                  ) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: voice,
                      child: Text('${voice['name']} (${voice['locale']})'),
                    );
                  }).toList(),
                  onChanged: (voice) async {
                    if (voice == null) return;
                    setState(() => _selectedVoice = voice);
                    await _tts.setVoice(voice);
                    await _tts.setLanguage(voice['locale']!);
                  },
                ),
                SizedBox(height: 16),
              ],

              // Traducción actual
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    _currentTranslation,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Historial
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Historial:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: _history.isEmpty
                          ? Center(child: Text('Sin historial aún.'))
                          : ListView.builder(
                              itemCount: _history.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.translate),
                                  title: Text(_history[index]),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

              // Botón de simulación
              ElevatedButton(
                onPressed: _isTranslating ? _simulateTranslation : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Simular Traducción',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
