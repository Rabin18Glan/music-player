import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:music_player/presentation/pages/now_playing_page.dart';
import 'package:flutter/gestures.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioLoaded) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NowPlayingPage()),
              );
            },
            child: Container(
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: AppTheme.gradientBoxDecoration(
                borderRadius: 20.0,
                gradient: AppTheme.surfaceGradient,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: LinearProgressIndicator(
                      value:
                          (state.currentSong.duration != null &&
                                  state.currentSong.duration! > 0)
                              ? state.position.inMilliseconds /
                                  state.currentSong.duration!
                              : 0.0,
                      backgroundColor: AppTheme.disabledTextColor.withAlpha(
                        100,
                      ),

                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.highlightColor,
                      ),
                      minHeight: 3,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: AppTheme.glowEffect(
                              AppTheme.elevatedColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  File(state.currentSong.data).existsSync()
                                      ? Image.file(
                                        File(state.currentSong.data),
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Icon(
                                            Icons.music_note,
                                            color: AppTheme.secondaryTextColor,
                                            size: 30,
                                          );
                                        },
                                      )
                                      : Icon(
                                        Icons.music_note,
                                        color: AppTheme.secondaryTextColor,
                                        size: 30,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.currentSong.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.currentSong.artist ?? "Unknown Artist",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondaryTextColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  state.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  color: AppTheme.highlightColor,
                                  size: 32,
                                ),
                                onPressed: () {
                                  if (state.isPlaying) {
                                    context.read<AudioBloc>().add(PauseSong());
                                  } else {
                                    context.read<AudioBloc>().add(ResumeSong());
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: AppTheme.accentColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  // Implement next song
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
