import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../services/ai_analysis_service.dart';
import 'timeline_feedback_screen.dart';

class AnalysisResultsScreen extends StatefulWidget {
  const AnalysisResultsScreen({super.key});

  @override
  State<AnalysisResultsScreen> createState() => _AnalysisResultsScreenState();
}

class _AnalysisResultsScreenState extends State<AnalysisResultsScreen> {
  final VocalAnalysisProvider _analysisProvider = VocalAnalysisProvider();
  bool _isAnalyzing = true;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _performAnalysis();
  }

  Future<void> _performAnalysis() async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    
    if (audioProvider.audioFilePath == null) {
      // Handle error case
      setState(() {
        _isAnalyzing = false;
      });
      return;
    }

    await _analysisProvider.performAnalysis(
      userAudioPath: audioProvider.audioFilePath!,
      referenceAudioPath: null, // In a real app, this would be the reference track path
      onProgress: (progress) {
        setState(() {
          _progress = progress;
        });
      },
    );

    setState(() {
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
      ),
      body: _isAnalyzing
          ? _buildAnalyzingView()
          : _buildResultsView(),
    );
  }

  Widget _buildAnalyzingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: _progress,
          ),
          const SizedBox(height: 24),
          const Text(
            'Analyzing your vocal performance...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${(_progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis Complete!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'We\'ve analyzed your vocal performance and identified key areas of strength and opportunities for improvement.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Summary:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  title: 'Strengths',
                  items: [
                    'Good breath support',
                    'Excellent phrasing',
                    'Clear diction',
                  ],
                  icon: Icons.thumb_up,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  title: 'Areas to Improve',
                  items: [
                    'Pitch accuracy in higher register',
                    'Dynamic contrast',
                    'Vibrato control',
                  ],
                  icon: Icons.trending_up,
                  color: Colors.amber,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimelineFeedbackScreen(
                    feedbackItems: _analysisProvider.feedbackItems,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('View Detailed Feedback'),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 16,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
