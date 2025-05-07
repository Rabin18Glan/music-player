import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/core/utils/duration_formatter.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:music_player/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:music_player/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'dart:io';

class SongTile extends StatelessWidget {
  final SongModel song;
  final bool isPlaying;
  final bool isFavorite;

  const SongTile({
    super.key,
    required this.song,
    this.isPlaying = false,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient:
            isPlaying
                ? LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.15),
                    AppTheme.accentColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
        color: isPlaying ? null : AppTheme.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        boxShadow:
            isPlaying
                ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
                : null,
        border:
            isPlaying
                ? Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 1.5,
                )
                : null,
      ),
      child: InkWell(
        onTap: () {
          context.read<AudioBloc>().add(PlaySong(song));
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: AppTheme.primaryColor.withOpacity(0.1),
        highlightColor: AppTheme.accentColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Album Art Container
              _buildAlbumCover(),

              const SizedBox(width: 16),

              // Song Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        fontWeight:
                            isPlaying ? FontWeight.bold : FontWeight.w500,
                        fontSize: 16,
                        color:
                            isPlaying
                                ? AppTheme.primaryColor
                                : Theme.of(context).textTheme.titleLarge?.color,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${song.artist ?? "Unknown Artist"} • ${song.album ?? "Unknown Album"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Duration Text
              Text(
                DurationFormatter.formatDuration(
                  Duration(milliseconds: song.duration ?? 180000),
                ),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      isPlaying
                          ? AppTheme.accentColor
                          : Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),

              // Favorite Button
              _buildFavoriteButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumCover() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.7),
            AppTheme.accentColor.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            song.data != null
                ? Image.file(
                  File(song.data!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildMusicIcon();
                  },
                )
                : _buildMusicIcon(),
      ),
    );
  }

  Widget _buildMusicIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.7),
            AppTheme.accentColor.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.music_note_rounded, color: Colors.white, size: 28),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: () {
          if (isFavorite) {
            context.read<FavoritesBloc>().add(RemoveFromFavorites(song));
          } else {
            context.read<FavoritesBloc>().add(AddToFavorites(song));
          }
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color:
                  isFavorite
                      ? AppTheme.dangerColor
                      : Theme.of(context).iconTheme.color?.withOpacity(0.6),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
