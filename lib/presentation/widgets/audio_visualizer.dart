import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/bloc/audio_bloc.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'dart:math' as math;

class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({super.key});

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<int> _waveformData = List.generate(50, (index) => 0);
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..repeat(reverse: true);

    _animationController.addListener(() {
      if (mounted) {
        setState(() {
          // Generate random waveform data for visualization
          for (int i = 0; i < _waveformData.length; i++) {
            _waveformData[i] = (_random.nextInt(80) + 20);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioPlaying) {
          if (state.isPlaying) {
            _animationController.repeat(reverse: true);
          } else {
            _animationController.stop();
          }

          return Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AudioWaveforms(
              enableGesture: false,
              size: Size(MediaQuery.of(context).size.width - 48, 80),
              recorderController: RecorderController(),
              waveStyle: const WaveStyle(
                waveColor: AppTheme.primaryColor,
                extendWaveform: true,
                showMiddleLine: false,
                spacing: 5,
                waveThickness: 3,
                showDurationLabel: false,
                showBottom: false,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
              ),
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,

              // animationCurve: Curves.easeInOut,
              // playerWaveStyle: const PlayerWaveStyle(
              // fixedWaveColor: Colors.white54,
              // liveWaveColor: AppTheme.primaryColor,
              // spacing: 6,
              // waveThickness: 4,
              // ),
              // playerController: PlayerController(),
              // samplingRate: 44100,
              // shouldCalculateScrolledPosition: false,
            ),
          );
        }

        return const SizedBox(height: 80);
      },
    );
  }
}
