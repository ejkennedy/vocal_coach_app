import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import 'analysis_preparation_screen.dart';

class YoutubeUrlScreen extends StatefulWidget {
  const YoutubeUrlScreen({super.key});

  @override
  State<YoutubeUrlScreen> createState() => _YoutubeUrlScreenState();
}

class _YoutubeUrlScreenState extends State<YoutubeUrlScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isValidUrl = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  bool _validateYoutubeUrl(String url) {
    // Basic validation for YouTube URLs
    return url.isNotEmpty && 
           (url.contains('youtube.com/watch?v=') || 
            url.contains('youtu.be/'));
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter YouTube URL'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            const Text(
              'Enter YouTube URL\nof original song',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // YouTube URL input field
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Enter YouTube URL of original',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.content_paste),
                  onPressed: () async {
                    // Implement paste functionality
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _isValidUrl = _validateYoutubeUrl(value);
                });
              },
            ),
            
            const SizedBox(height: 30),
            
            // YouTube preview (placeholder)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _isValidUrl
                    ? const Icon(Icons.play_arrow, size: 60, color: Colors.white)
                    : const Icon(Icons.video_library, size: 60, color: Colors.grey),
              ),
            ),
            
            const Spacer(),
            
            // Convert button
            ElevatedButton(
              onPressed: _isValidUrl && !_isLoading
                  ? () async {
                      setState(() {
                        _isLoading = true;
                      });
                      
                      // Set the YouTube URL in the provider
                      audioProvider.setYoutubeUrl(_urlController.text);
                      
                      // Simulate conversion process
                      await Future.delayed(const Duration(seconds: 2));
                      
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnalysisPreparationScreen(),
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'CONVERT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
