import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/bloc/audio_bloc.dart';
import 'package:music_player/presentation/pages/now_playing_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioPlaying) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NowPlayingPage()),
              );
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Prevent overflow by limiting size
                children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value:
                        (state.currentSong.duration != null &&
                                state.currentSong.duration! > 0)
                            ? state.position.inMilliseconds /
                                state.currentSong.duration!
                            : 0.0, // Default to 0 if duration is invalid
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    minHeight: 2,
                  ),

                  // Player controls
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Song info
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child:
                                        File(
                                              state.currentSong.data,
                                            ).existsSync()
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
                                                  color: AppTheme.primaryColor,
                                                  size: 30,
                                                );
                                              },
                                            )
                                            : Icon(
                                              Icons.music_note,
                                              color: AppTheme.primaryColor,
                                              size: 30,
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.currentSong.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        state.currentSong.artist ?? "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.7),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Control buttons
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  state.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: AppTheme.primaryColor,
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
                                icon: const Icon(Icons.skip_next),
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
