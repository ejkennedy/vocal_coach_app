# AI Vocal Coach Flutter Application - User Guide

## Overview

The AI Vocal Coach is a Flutter application designed to help singers improve their vocal performances through AI-powered feedback. The app allows users to upload their vocal recordings, categorize them as original compositions or covers, and receive detailed, timestamped feedback on their performances.

## Features

### MP3 Upload and Categorization
- Upload your vocal recordings in MP3 format
- Categorize recordings as either original compositions or covers of existing songs

### YouTube Reference Track Integration
- For cover performances, provide a YouTube URL of the original song
- The app automatically extracts and converts the audio for comparison

### AI Vocal Analysis
- Advanced AI analysis of your vocal performance
- For covers: comparison against the original reference track
- Analysis of pitch accuracy, timing, breath control, tone, and more

### Timeline-Based Feedback
- Interactive timeline with markers at specific feedback points
- Color-coded feedback (green for strengths, yellow for suggestions, red for corrections)
- Playback controls synchronized with feedback display
- Detailed feedback panel showing specific comments at each timestamp

## Getting Started

### Prerequisites
- Flutter SDK (version 3.19.3 or higher)
- Android Studio or VS Code with Flutter plugins
- Android device/emulator or iOS device/simulator

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/vocal_coach_app.git
   ```

2. Navigate to the project directory:
   ```
   cd vocal_coach_app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Usage Guide

### Uploading a Vocal Recording
1. Launch the app
2. Tap the "Upload" button on the home screen
3. Select an MP3 file from your device

### Categorizing Your Recording
1. After uploading, choose either "Original Composition" or "Cover Performance"
2. For covers, you'll be prompted to enter a YouTube URL of the original song

### Viewing Analysis Results
1. Wait for the analysis to complete
2. Review the summary of strengths and areas for improvement
3. Tap "View Detailed Feedback" to see the timeline view

### Using the Timeline Feedback
1. Play your recording using the playback controls
2. Tap on timeline markers to jump to specific feedback points
3. View detailed feedback for each marker
4. Scroll through the list of all feedback items below the timeline

## Technical Details

The application is built using:
- Flutter framework for cross-platform compatibility
- Provider package for state management
- just_audio for audio playback
- youtube_explode_dart for YouTube audio extraction
- audio_waveforms for waveform visualization

## Future Enhancements

Potential future improvements include:
- User accounts and progress tracking
- Sharing capabilities for performances and feedback
- Guided vocal exercises based on feedback
- Community features for peer feedback
- Advanced analytics on vocal improvement over time

## Support

For issues, questions, or feature requests, please contact support at support@vocalcoach.com or open an issue on the GitHub repository.
