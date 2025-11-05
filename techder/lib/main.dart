import 'package:flutter/material.dart';
import 'languages.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const TechTinderApp());
}

class TechTinderApp extends StatelessWidget {
  const TechTinderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechTinder',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFF1a1a1a),
        cardTheme: const CardThemeData(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ProgrammingLanguage and languages data moved to `lib/languages.dart`

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<ProgrammingLanguage> _matches = [];
  final List<ProgrammingLanguage> _skipped = [];
  late List<ProgrammingLanguage> _languages;

  @override
  void initState() {
    super.initState();
    // Start with a shuffled copy of all languages so the user sees a random order each session
    _languages = List<ProgrammingLanguage>.from(allLanguages)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: _currentIndex == 0 ? _buildSwipeView() : _buildMatchesView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF2a2a2a),
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Matches',
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeView() {
  final availableLanguages =
    _languages.where((lang) => !_matches.contains(lang) && !_skipped.contains(lang)).toList();

    if (availableLanguages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.pink),
            const SizedBox(height: 20),
            const Text(
              'No more languages!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Check your ${_matches.length} matches',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    final currentLanguage = availableLanguages[0];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TechTinder',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_matches.length} matches',
                    style: const TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildLanguageCard(currentLanguage),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.close,
                  color: Colors.red,
                  onPressed: _skipLanguage,
                ),
                _buildActionButton(
                  icon: Icons.favorite,
                  color: Colors.pink,
                  size: 70,
                  onPressed: _likeLanguage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(ProgrammingLanguage language) {
    return Card(
      color: const Color(0xFF2a2a2a),
      child: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              language.emoji,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            Text(
              language.name,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              language.tagline,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Display difficulty and tags
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Chip(
                  label: Text(language.difficulty,
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: language.difficulty.toLowerCase() == 'easy'
                      ? Colors.green
                      : language.difficulty.toLowerCase() == 'hard'
                          ? Colors.red
                          : Colors.orange,
                ),
                ...language.tags.map((t) => Chip(
                      label: Text(t, style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.grey[700],
                    )),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  language.bio,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 60,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: size * 0.5),
          ),
        ),
      ),
    );
  }

  void _skipLanguage() {
    final availableLanguages =
        _languages.where((lang) => !_matches.contains(lang) && !_skipped.contains(lang)).toList();

    if (availableLanguages.isNotEmpty) {
      setState(() {
        // Add the current language to skipped so it won't appear again
        _skipped.add(availableLanguages[0]);
      });
    }
  }

  void _likeLanguage() {
    final availableLanguages =
        _languages.where((lang) => !_matches.contains(lang) && !_skipped.contains(lang)).toList();

    if (availableLanguages.isNotEmpty) {
      setState(() {
        _matches.add(availableLanguages[0]);
      });
    }
  }

  Widget _buildMatchesView() {
    if (_matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No matches yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Start swiping to find your perfect language!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Matches',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final language = _matches[index];
                return _buildMatchCard(language);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(ProgrammingLanguage language) {
    return Card(
      color: const Color(0xFF2a2a2a),
      child: InkWell(
        onTap: () => _openProfile(language),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                language.emoji,
                style: const TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 12),
              Text(
                language.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              // show small tag chips on match cards
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                children: [
                  Chip(
                    label: Text(language.difficulty, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    backgroundColor: language.difficulty.toLowerCase() == 'easy'
                        ? Colors.green
                        : language.difficulty.toLowerCase() == 'hard'
                            ? Colors.red
                            : Colors.orange,
                    visualDensity: VisualDensity.compact,
                  ),
                  ...language.tags.map((t) => Chip(
                        label: Text(t, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: Colors.grey[700],
                        visualDensity: VisualDensity.compact,
                      )),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  language.tagline,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openProfile(ProgrammingLanguage language) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(language: language),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final ProgrammingLanguage language;

  const ProfileScreen({Key? key, required this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2a2a2a),
        title: Text(language.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF2a2a2a),
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    language.emoji,
                    style: const TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    language.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    language.tagline,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            _buildSection(
              'About',
              language.description,
            ),
            _buildSection(
              'Common Use Cases',
              language.useCases,
            ),
            _buildCodeSection(
              'Sample Code',
              language.sampleCode,
            ),
            _buildResourcesSection(
              context,
              'Learning Resources',
              language.resources,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSection(String title, String code) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2a2a2a),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.greenAccent,
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection(BuildContext context, String title, List<String> resources) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 12),
          ...resources.map((resource) {
            // Expect resource strings in format: "Label - https://..."
            final parts = resource.split(' - ');
            final label = parts.isNotEmpty ? parts[0] : resource;
            final url = parts.length > 1 ? parts.sublist(1).join(' - ').trim() : '';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.book,
                    color: Colors.pink,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: url.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              try {
                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Could not open: $url')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Invalid URL: $url')),
                                );
                              }
                            },
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.lightBlueAccent,
                                height: 1.5,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        : Text(
                            label,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
