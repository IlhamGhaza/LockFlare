import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
      final stats = await _gitHubService.getUserStats(
          'ilhamghaza'); 
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Animated App Bar with Profile Image
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
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated Background Pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BackgroundPatternPainter(
                          color: colorScheme.onPrimary.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // Profile Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.onPrimary,
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
                                    child: _githubStats?['avatar_url'] == null
                                        ? const Icon(Icons.person, size: 50)
                                        : null,
                                  ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _githubStats?['name'] ?? 'Loading...',
                            style: textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@IlhamGhaza',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary.withOpacity(0.8),
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

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Me Section with Animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'About Me',
                              style: textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          'Software Developer | Flutter Enthusiast',
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Passionate about creating beautiful and functional mobile applications using Flutter.',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // GitHub Stats with Modern Design
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.code,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'GitHub Stats',
                              style: textTheme.titleLarge,
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
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.error,
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
                                        colorScheme.primary,
                                      ),
                                      _buildStatItem(
                                        context,
                                        Icons.source_outlined,
                                        'Repositories',
                                        _githubStats?['public_repos']
                                                .toString() ??
                                            '0',
                                        colorScheme.secondary,
                                      ),
                                      _buildStatItem(
                                        context,
                                        Icons.people_outline,
                                        'Followers',
                                        _githubStats?['followers'].toString() ??
                                            '0',
                                        colorScheme.tertiary,
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buy Me a Coffee Banner with Modern Design
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber[200]!.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
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
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.brown[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
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

// Custom Painter untuk background pattern
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
