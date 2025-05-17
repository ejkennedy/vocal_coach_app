import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_analysis_service.dart';
import '../providers/audio_provider.dart';

class TimelineFeedbackScreen extends StatefulWidget {
  final List<FeedbackItem> feedbackItems;
  
  const TimelineFeedbackScreen({
    super.key,
    required this.feedbackItems,
  });

  @override
  State<TimelineFeedbackScreen> createState() => _TimelineFeedbackScreenState();
}

class _TimelineFeedbackScreenState extends State<TimelineFeedbackScreen> {
  FeedbackItem? _selectedFeedback;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.feedbackItems.isNotEmpty) {
      _selectedFeedback = widget.feedbackItems.first;
    }
    
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocal Analysis'),
      ),
      body: Column(
        children: [
          // Audio waveform with markers
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Waveform visualization with markers
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Placeholder waveform
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            40,
                            (index) => Container(
                              width: 6,
                              height: 40 + (index % 7) * 10.0,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Feedback markers
                      ...widget.feedbackItems.map((item) {
                        // Calculate position based on timestamp and total duration
                        final position = item.timestamp.inMilliseconds / 
                                        audioProvider.duration.inMilliseconds;
                        
                        return Positioned(
                          left: position * MediaQuery.of(context).size.width * 0.9,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFeedback = item;
                              });
                              audioProvider.seekAudio(item.timestamp);
                            },
                            child: Container(
                              width: 4,
                              color: _getMarkerColor(item.type),
                            ),
                          ),
                        );
                      }).toList(),
                      
                      // Current position indicator
                      Positioned(
                        left: (audioProvider.position.inMilliseconds / 
                               audioProvider.duration.inMilliseconds) * 
                               MediaQuery.of(context).size.width * 0.9,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Playback controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 40,
                      onPressed: () {
                        if (_isPlaying) {
                          audioProvider.pauseAudio();
                        } else {
                          audioProvider.playAudio();
                        }
                      },
                    ),
                    Expanded(
                      child: Slider(
                        value: audioProvider.position.inMilliseconds.toDouble(),
                        max: audioProvider.duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          audioProvider.seekAudio(Duration(milliseconds: value.toInt()));
                        },
                      ),
                    ),
                    Text(
                      _formatDuration(audioProvider.position) + ' / ' + 
                      _formatDuration(audioProvider.duration),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Current feedback display
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Feedback',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                if (_selectedFeedback != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedFeedback!.getColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedFeedback!.message,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: _selectedFeedback!.getTextColor(),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          _formatDuration(_selectedFeedback!.timestamp),
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedFeedback!.getTextColor().withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // All feedback items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.feedbackItems.length,
              itemBuilder: (context, index) {
                final item = widget.feedbackItems[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFeedback = item;
                    });
                    audioProvider.seekAudio(item.timestamp);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: item.getColor(),
                      borderRadius: BorderRadius.circular(12),
                      border: _selectedFeedback == item
                          ? Border.all(
                              color: item.getTextColor(),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          _formatDuration(item.timestamp),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: item.getTextColor(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item.message,
                            style: TextStyle(
                              color: item.getTextColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
  
  Color _getMarkerColor(FeedbackType type) {
    switch (type) {
      case FeedbackType.positive:
        return Colors.green;
      case FeedbackType.suggestion:
        return Colors.amber;
      case FeedbackType.correction:
        return Colors.red;
    }
  }
}
