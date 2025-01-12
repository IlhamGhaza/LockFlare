import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme/bloc/theme_cubit.dart';
import '../config/theme/theme.dart';
import '../data/github_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GitHubService _gitHubService = GitHubService();
  Map<String, dynamic>? _githubStats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGitHubStats();
  }

  Future<void> _loadGitHubStats() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('Starting to load GitHub stats...');
      final stats = await _gitHubService.getUserStats('ilhamghaza');
      print('Received stats: $stats');

      if (mounted) {
        setState(() {
          _githubStats = stats;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error loading GitHub stats: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;
        final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: BackgroundPatternPainter(
                              color:
                                  theme.colorScheme.onPrimary.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.onPrimary,
                                    width: 2,
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircleAvatar(
                                        radius: 50,
                                        child: CircularProgressIndicator(),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            _githubStats?['avatar_url'] != null
                                                ? NetworkImage(
                                                    _githubStats!['avatar_url'])
                                                : null,
                                        child: _githubStats?['avatar_url'] ==
                                                null
                                            ? const Icon(Icons.person, size: 50)
                                            : null,
                                      ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _githubStats?['name'] ?? 'Loading...',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                              ),
                              Text(
                                '@IlhamGhaza',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: theme.colorScheme.onPrimary
                                          .withOpacity(0.8),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 24,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'About Me',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Text(
                              'Software Developer | Flutter Enthusiast',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Passionate about creating beautiful and functional mobile applications using Flutter.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.code,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'GitHub Stats',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _isLoading
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(height: 16),
                                          Text('Loading GitHub stats...'),
                                        ],
                                      ),
                                    ),
                                  )
                                : _error != null
                                    ? Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              'Error loading stats',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        theme.colorScheme.error,
                                                  ),
                                            ),
                                            TextButton(
                                              onPressed: _loadGitHubStats,
                                              child: const Text('Retry'),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildStatItem(
                                            context,
                                            Icons.star_border,
                                            'Stars',
                                            _githubStats?['stars'].toString() ??
                                                '0',
                                            theme.colorScheme.primary,
                                          ),
                                          _buildStatItem(
                                            context,
                                            Icons.source_outlined,
                                            'Repositories',
                                            _githubStats?['public_repos']
                                                    .toString() ??
                                                '0',
                                            theme.colorScheme.secondary,
                                          ),
                                          _buildStatItem(
                                            context,
                                            Icons.people_outline,
                                            'Followers',
                                            _githubStats?['followers']
                                                    .toString() ??
                                                '0',
                                            theme.colorScheme.primary,
                                          ),
                                        ],
                                      ),
                          ],
                        ),
                      ),
                      //list for theme
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              themeMode == ThemeMode.dark
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              key: ValueKey(themeMode),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            'Dark Mode',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                            builder: (context, themeMode) {
                              return Switch(
                                value: themeMode == ThemeMode.dark,
                                onChanged: (value) {
                                  context.read<ThemeCubit>().updateTheme(
                                      value ? ThemeMode.dark : ThemeMode.light);
                                },
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                              );
                            },
                          ),
                        ),
                      //   child: ListTile(
                      //     leading: AnimatedSwitcher(
                      //       duration: const Duration(milliseconds: 300),
                      //       child: Icon(
                      //         themeMode == ThemeMode.dark
                      //             ? Icons.dark_mode
                      //             : (themeMode == ThemeMode.light
                      //                 ? Icons.light_mode
                      //                 : Icons.brightness_auto),
                      //         key: ValueKey(themeMode),
                      //         color: Theme.of(context).colorScheme.primary,
                      //       ),
                      //     ),
                      //     title: Text(
                      //       'Theme Mode',
                      //       style: Theme.of(context).textTheme.titleMedium,
                      //     ),
                      //     trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                      //       builder: (context, themeMode) {
                      //         return DropdownButton<ThemeMode>(
                      //           value: themeMode,
                      //           onChanged: (ThemeMode? newThemeMode) {
                      //             if (newThemeMode != null) {
                      //               context
                      //                   .read<ThemeCubit>()
                      //                   .updateTheme(newThemeMode);
                      //             }
                      //           },
                      //           items: const [
                      //             DropdownMenuItem(
                      //               value: ThemeMode.system,
                      //               child: Text('System'),
                      //             ),
                      //             DropdownMenuItem(
                      //               value: ThemeMode.light,
                      //               child: Text('Light'),
                      //             ),
                      //             DropdownMenuItem(
                      //               value: ThemeMode.dark,
                      //               child: Text('Dark'),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     ),
                      //   ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL('https://www.buymeacoffee.com/IlhamGhaza');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber[300]!,
                                Colors.amber[400]!,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.coffee,
                                color: Colors.brown[900],
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Buy Me a Coffee',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.brown[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < size.width; i += 20) {
      for (var j = 0; j < size.height; j += 20) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
