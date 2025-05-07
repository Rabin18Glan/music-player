import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioLoaded) {
          return Column(
            children: [
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ProgressBar(
                      progress: state.position,
                      total: Duration(minutes: state.currentSong.duration ?? 3),
                      onSeek: (position) {
                        context.read<AudioBloc>().add(SeekToPosition(position));
                      },
                      thumbColor: AppTheme.primaryColor,
                      progressBarColor: AppTheme.primaryColor,
                      baseBarColor: AppTheme.primaryColor.withOpacity(0.3),
                      thumbRadius: 8,
                      barHeight: 4,
                      timeLabelTextStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    icon: Icons.shuffle,
                    onPressed: () {
                      // Implement shuffle functionality
                    },
                    color: Colors.white.withOpacity(0.7),
                    size: 28,
                  ),
                  const SizedBox(width: 20),
                  _buildControlButton(
                    icon: Icons.skip_previous,
                    onPressed: () {
                      // Implement previous song
                    },
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 20),
                  _buildPlayPauseButton(
                    isPlaying: state.isPlaying,
                    onPlayPause: () {
                      if (state.isPlaying) {
                        context.read<AudioBloc>().add(PauseSong());
                      } else {
                        context.read<AudioBloc>().add(ResumeSong());
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildControlButton(
                    icon: Icons.skip_next,
                    onPressed: () {
                      // Implement next song
                    },
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 20),
                  _buildControlButton(
                    icon: Icons.repeat,
                    onPressed: () {
                      // Implement repeat functionality
                    },
                    color: Colors.white.withOpacity(0.7),
                    size: 28,
                  ),
                ],
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required double size,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color,
      iconSize: size,
    );
  }

  Widget _buildPlayPauseButton({
    required bool isPlaying,
    required VoidCallback onPlayPause,
  }) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
        onPressed: onPlayPause,
        color: Colors.white,
        iconSize: 40,
      ),
    );
  }
}
