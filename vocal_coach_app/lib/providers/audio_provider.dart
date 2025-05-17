import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider extends ChangeNotifier {
  File? _audioFile;
  String? _audioFilePath;
  String? _audioFileName;
  bool _isOriginal = true;
  String? _youtubeUrl;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  File? get audioFile => _audioFile;
  String? get audioFilePath => _audioFilePath;
  String? get audioFileName => _audioFileName;
  bool get isOriginal => _isOriginal;
  String? get youtubeUrl => _youtubeUrl;
  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;

  AudioProvider() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((newDuration) {
      if (newDuration != null) {
        _duration = newDuration;
        notifyListeners();
      }
    });

    _audioPlayer.positionStream.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });
  }

  Future<bool> pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        _audioFile = File(result.files.single.path!);
        _audioFilePath = result.files.single.path;
        _audioFileName = result.files.single.name;
        
        // Load the audio file into the player
        await _audioPlayer.setFilePath(_audioFilePath!);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error picking audio file: $e');
      return false;
    }
  }

  void setAudioType(bool isOriginal) {
    _isOriginal = isOriginal;
    notifyListeners();
  }

  void setYoutubeUrl(String url) {
    _youtubeUrl = url;
    notifyListeners();
  }

  Future<void> playAudio() async {
    if (_audioFilePath != null) {
      await _audioPlayer.play();
    }
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void resetAudio() {
    _audioFile = null;
    _audioFilePath = null;
    _audioFileName = null;
    _isOriginal = true;
    _youtubeUrl = null;
    _audioPlayer.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
