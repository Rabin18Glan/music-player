import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:music_player/presentation/pages/albums_page.dart';
import 'package:music_player/presentation/pages/playlists_page.dart';
import 'package:music_player/presentation/pages/songs_page.dart';
import 'package:music_player/presentation/widgets/mini_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load favorites
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [SongsPage(), AlbumsPage(), PlaylistsPage()],
              ),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'MUSIC',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 8,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, size: 26),
                onPressed: () {
                  // Implement search functionality
                },
                color: Colors.white,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 18),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 26),
                onPressed: () {
                  // Navigate to settings
                },
                color: Colors.white,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.accentColor,
        indicatorWeight: 2,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        dividerHeight: 0,
        tabs: const [
          Tab(text: 'SONGS'),
          Tab(text: 'ALBUMS'),
          Tab(text: 'PLAYLISTS'),
        ],
      ),
    );
  }
}
