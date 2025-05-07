import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/core/utils/duration_formatter.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:music_player/presentation/bloc/audio_bloc.dart';
import 'package:music_player/presentation/bloc/favorites_bloc.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color:
            isPlaying
                ? AppTheme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              song.data != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(song.data!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.music_note,
                          color: AppTheme.primaryColor,
                          size: 30,
                        );
                      },
                    ),
                  )
                  : Icon(
                    Icons.music_note,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
        ),
        title: Text(
          song.title,
          style: TextStyle(
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
            color:
                isPlaying
                    ? AppTheme.primaryColor
                    : Theme.of(context).textTheme.titleLarge?.color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${song.artist} • ${song.album}',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DurationFormatter.formatDuration(
                Duration(minutes: song.duration ?? 3),
              ),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppTheme.primaryColor : null,
              ),
              onPressed: () {
                if (isFavorite) {
                  context.read<FavoritesBloc>().add(RemoveFromFavorites(song));
                } else {
                  context.read<FavoritesBloc>().add(AddToFavorites(song));
                }
              },
            ),
          ],
        ),
        onTap: () {
          context.read<AudioBloc>().add(PlaySong(song));
        },
      ),
    );
  }
}
