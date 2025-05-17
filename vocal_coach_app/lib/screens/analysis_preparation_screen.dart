import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/audio_provider.dart';

class YoutubeService {
  static final YoutubeExplode _yt = YoutubeExplode();
  
  static Future<String?> downloadYoutubeAudio(String url, {Function(double)? onProgress}) async {
    try {
      // Get video metadata
      Video video = await _yt.videos.get(url);
      
      // Get the best audio-only stream
      StreamManifest manifest = await _yt.videos.streamsClient.getManifest(video.id);
      AudioOnlyStreamInfo audioStream = manifest.audioOnly.withHighestBitrate();
      
      // Get the download stream
      Stream<List<int>> stream = _yt.videos.streamsClient.get(audioStream);
      
      // Get file size for progress calculation
      int fileSize = audioStream.size.totalBytes;
      int downloaded = 0;
      
      // Create a temporary file to store the audio
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/${video.id}.mp3';
      File file = File(filePath);
      
      // Create file and write stream data with progress updates
      IOSink sink = file.openWrite();
      await stream.listen((data) {
        sink.add(data);
        downloaded += data.length;
        if (onProgress != null) {
          onProgress(downloaded / fileSize);
        }
      }).asFuture();
      
      await sink.flush();
      await sink.close();
      
      return filePath;
    } catch (e) {
      print('Error downloading YouTube audio: $e');
      return null;
    } finally {
      _yt.close();
    }
  }
}

class AnalysisPreparationScreen extends StatefulWidget {
  const AnalysisPreparationScreen({super.key});

  @override
  State<AnalysisPreparationScreen> createState() => _AnalysisPreparationScreenState();
}

class _AnalysisPreparationScreenState extends State<AnalysisPreparationScreen> {
  bool _isProcessing = false;
  double _progress = 0.0;
  String _statusMessage = 'Preparing for analysis...';

  @override
  void initState() {
    super.initState();
    _prepareForAnalysis();
  }

  Future<void> _prepareForAnalysis() async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    
    setState(() {
      _isProcessing = true;
    });
    
    // If this is a cover, download the YouTube reference
    if (!audioProvider.isOriginal && audioProvider.youtubeUrl != null) {
      setState(() {
        _statusMessage = 'Downloading reference track...';
      });
      
      final String? referenceFilePath = await YoutubeService.downloadYoutubeAudio(
        audioProvider.youtubeUrl!,
        onProgress: (progress) {
          setState(() {
            _progress = progress;
          });
        },
      );
      
      if (referenceFilePath == null) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Failed to download reference track';
        });
        return;
      }
      
      // Here you would store the reference file path in the provider
      // audioProvider.setReferenceFilePath(referenceFilePath);
    }
    
    // Simulate AI analysis process
    setState(() {
      _statusMessage = 'Analyzing vocal performance...';
      _progress = 0.0;
    });
    
    // Simulate analysis progress
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _progress = i / 100;
      });
    }
    
    setState(() {
      _isProcessing = false;
    });
    
    // Navigate to results screen
    if (mounted) {
      // Navigate to analysis results screen
      // This will be implemented in the next step
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preparing Analysis'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isProcessing) ...[
                CircularProgressIndicator(
                  value: _progress > 0 ? _progress : null,
                ),
                const SizedBox(height: 24),
                Text(
                  _statusMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ] else ...[
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Analysis complete!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to results screen
                    // This will be implemented in the next step
                  },
                  child: const Text('View Results'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
