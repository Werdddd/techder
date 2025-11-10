import 'package:flutter/material.dart';
import 'languages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';



void main() {
  runApp(const TechderApp());
}

class TechderApp extends StatelessWidget {
  const TechderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Techder',
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
  final Set<String> _activeTagFilters = {};
  int _quizScore = 0;

  @override
  void initState() {
    super.initState();
    _languages = List<ProgrammingLanguage>.from(allLanguages)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildSwipeView(),
          _buildMatchesView(),
          _buildLearnView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF2a2a2a),
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Matches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Learn',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeView() {
    final availableLanguages = _languages
        .where((lang) => !_matches.contains(lang) && !_skipped.contains(lang))
        .toList();

    if (availableLanguages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.pink.withOpacity(0.3), Colors.purple.withOpacity(0.3)],
                ),
              ),
              child: const Icon(Icons.check_circle, size: 80, color: Colors.pink),
            ),
            const SizedBox(height: 24),
            const Text(
              'All Caught Up!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Check your ${_matches.length} matches',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => setState(() => _currentIndex = 1),
              icon: const Icon(Icons.favorite),
              label: const Text('View Matches'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
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
          _buildAppBar(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildLanguageCard(currentLanguage),
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2a2a2a),
            const Color(0xFF1a1a1a),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.pinkAccent],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.code, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Techder',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.withOpacity(0.3), Colors.purple.withOpacity(0.3)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pink.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.pink, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${_matches.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
      elevation: 12,
      shadowColor: Colors.pink.withOpacity(0.3),
      color: const Color(0xFF2a2a2a),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2a2a2a),
              const Color(0xFF2a2a2a).withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'language_${language.name}',
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink.withOpacity(0.2),
                      Colors.purple.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Text(
                  language.emoji,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              language.name,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pink.withOpacity(0.3)),
              ),
              child: Text(
                language.tagline,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[300],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip(
                  language.difficulty,
                  language.difficulty.toLowerCase() == 'easy'
                      ? Colors.green
                      : language.difficulty.toLowerCase() == 'hard'
                          ? Colors.red
                          : Colors.orange,
                ),
                ...language.tags.map((t) => _buildChip(t, Colors.purple)),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              height: 2,
              width: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pink, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  language.bio,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.6,
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

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1a1a1a),
            const Color(0xFF2a2a2a),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.close,
            color: Colors.red,
            onPressed: _skipLanguage,
            size: 65,
          ),
          _buildActionButton(
            icon: Icons.star,
            color: Colors.amber,
            onPressed: () {
              final available = _languages
                  .where((lang) => !_matches.contains(lang) && !_skipped.contains(lang))
                  .toList();
              if (available.isNotEmpty) {
                _openProfile(available[0]);
              }
            },
            size: 60,
          ),
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.pink,
            onPressed: _likeLanguage,
            size: 75,
          ),
        ],
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
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white, size: size * 0.5),
          ),
        ),
      ),
    );
  }

  void _skipLanguage() {
    final availableLanguages = _languages
        .where((lang) => !_matches.contains(lang) && !_skipped.contains(lang))
        .toList();

    if (availableLanguages.isNotEmpty) {
      setState(() {
        _skipped.add(availableLanguages[0]);
      });
    }
  }

  void _likeLanguage() {
    final availableLanguages = _languages
        .where((lang) => !_matches.contains(lang) && !_skipped.contains(lang))
        .toList();

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
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.grey.withOpacity(0.2), Colors.grey.withOpacity(0.1)],
                ),
              ),
              child: const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'No matches yet',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start swiping to find your perfect language!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => setState(() => _currentIndex = 0),
              icon: const Icon(Icons.explore),
              label: const Text('Start Discovering'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Matches',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.withOpacity(0.3), Colors.purple.withOpacity(0.3)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_matches.length} ${_matches.length == 1 ? 'match' : 'matches'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_matches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._availableMatchTags().map((tag) {
                    final selected = _activeTagFilters.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: selected,
                      onSelected: (v) => setState(() {
                        if (v) {
                          _activeTagFilters.add(tag);
                        } else {
                          _activeTagFilters.remove(tag);
                        }
                      }),
                      selectedColor: Colors.pink,
                      checkmarkColor: Colors.white,
                      backgroundColor: Colors.grey[800],
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }),
                  if (_activeTagFilters.isNotEmpty)
                    ActionChip(
                      label: const Text('Clear All'),
                      onPressed: () => setState(() => _activeTagFilters.clear()),
                      backgroundColor: Colors.red.withOpacity(0.3),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
          Expanded(
            child: Builder(builder: (context) {
              final filteredMatches = _activeTagFilters.isEmpty
                  ? _matches
                  : _matches.where((m) {
                      return _activeTagFilters.any((filter) {
                        if (filter == 'Easy' || filter == 'Normal' || filter == 'Hard') {
                          return m.difficulty.toLowerCase() == filter.toLowerCase();
                        }
                        return m.tags.contains(filter);
                      });
                    }).toList();

              if (filteredMatches.isEmpty) {
                return const Center(
                  child: Text(
                    'No matching languages',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredMatches.length,
                itemBuilder: (context, index) {
                  final language = filteredMatches[index];
                  return _buildMatchCard(language);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  List<String> _availableMatchTags() {
    final tags = <String>{};
    for (final m in _matches) {
      tags.addAll(m.tags);
    }
    tags.addAll(['Easy', 'Normal', 'Hard']);
    final list = tags.toList()
      ..sort((a, b) {
        const order = ['Easy', 'Normal', 'Hard'];
        final ai = order.contains(a) ? order.indexOf(a) : order.length;
        final bi = order.contains(b) ? order.indexOf(b) : order.length;
        if (ai != bi) return ai.compareTo(bi);
        return a.compareTo(b);
      });
    return list;
  }

  Widget _buildMatchCard(ProgrammingLanguage language) {
    return Card(
      elevation: 8,
      shadowColor: Colors.pink.withOpacity(0.2),
      color: const Color(0xFF2a2a2a),
      child: InkWell(
        onTap: () => _openProfile(language),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2a2a2a),
                const Color(0xFF2a2a2a).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'language_${language.name}',
                child: Text(
                  language.emoji,
                  style: const TextStyle(fontSize: 50),
                ),
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
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: [
                  _buildSmallChip(
                    language.difficulty,
                    language.difficulty.toLowerCase() == 'easy'
                        ? Colors.green
                        : language.difficulty.toLowerCase() == 'hard'
                            ? Colors.red
                            : Colors.orange,
                  ),
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

  Widget _buildSmallChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLearnView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Learning Center',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Test your knowledge and get personalized recommendations',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              _buildLearnCard(
                title: 'Quick Quiz',
                subtitle: 'Test your programming knowledge',
                icon: Icons.quiz,
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.purpleAccent],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      onComplete: (score) => setState(() => _quizScore = score),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLearnCard(
                title: 'Learning Path',
                subtitle: 'Get AI-powered recommendations',
                icon: Icons.route,
                gradient: const LinearGradient(
                  colors: [Colors.pink, Colors.pinkAccent],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearningPathScreen(
                      matches: _matches,
                      quizScore: _quizScore,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLearnCard(
                title: 'Compare Languages',
                subtitle: 'Side-by-side comparison tool',
                icon: Icons.compare_arrows,
                gradient: const LinearGradient(
                  colors: [Colors.cyan, Colors.cyanAccent],
                ),
                onTap: _matches.length >= 2
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompareScreen(languages: _matches),
                          ),
                        )
                    : null,
                disabled: _matches.length < 2,
              ),
              if (_quizScore > 0) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.withOpacity(0.2), Colors.orange.withOpacity(0.2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Quiz Score',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '$_quizScore / 5',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearnCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    VoidCallback? onTap,
    bool disabled = false,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.pink.withOpacity(0.2),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: disabled
                ? LinearGradient(
                    colors: [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)],
                  )
                : gradient,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      disabled ? 'Match with 2+ languages first' : subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(disabled ? 0.3 : 0.7),
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

// Add this to your main.dart file after the HomePage class

class ProfileScreen extends StatelessWidget {
  final ProgrammingLanguage language;

  const ProfileScreen({Key? key, required this.language}) : super(key: key);

  Widget _buildListSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.pink, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF1a1a1a),
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: const Color(0xFF2a2a2a),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2a2a2a),
                      const Color(0xFF2a2a2a).withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Hero(
                      tag: 'language_${language.name}',
                      child: Text(
                        language.emoji,
                        style: const TextStyle(fontSize: 100),
                      ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.pink.withOpacity(0.5)),
                      ),
                      child: Text(
                        language.tagline,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content section
          SliverToBoxAdapter(
            child: Padding(
              // 👇 adds bottom padding so FAB won’t overlap
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('About', language.description),
                  _buildListSection('Your 5-Step Roadmap', language.roadmap),
                  _buildSection('Common Use Cases', language.useCases),
                  _buildCodeSection('Sample Code', language.sampleCode),
                  _buildResourcesSection(context, 'Learning Resources', language.resources),
                ],
              ),
            ),
          ),
        ],
      ),
    ),

    // Floating chat button
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(language: language),
          ),
        );
      },
      label: Text('Chat with ${language.name}'),
      icon: const Icon(Icons.chat_bubble),
      backgroundColor: Colors.pink,
      elevation: 8,
    ),
  );
}


  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2a2a2a),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pink.withOpacity(0.3)),
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
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...resources.map((resource) {
            final parts = resource.split(' - ');
            final label = parts.isNotEmpty ? parts[0] : resource;
            final url = parts.length > 1 ? parts.sublist(1).join(' - ').trim() : '';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: url.isNotEmpty
                    ? () async {
                        try {
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not open: $url')),
                          );
                        }
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2a2a2a),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pink.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.pink, Colors.purple],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.book, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ),
                      if (url.isNotEmpty)
                        const Icon(Icons.open_in_new, color: Colors.pink, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final ProgrammingLanguage language;
  const ChatScreen({Key? key, required this.language}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  static const _kApiKey = "AIzaSyCS8xCajNNoLrnqCjp3i-RvzURldijgGOA";
  static const _kApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent';

  @override
  void initState() {
    super.initState();
    final initialMessage = widget.language.initialChat;
    _messages.add({'sender': 'AI', 'text': initialMessage});
  }

  Future<String> _handleGeminiRequest(String userQuery) async {
    final systemPrompt =
        "Act as you are in a dating app. You are the ${widget.language.name} Programming Language. Your responses should be playful, engaging, and based on your core features and use cases (${widget.language.useCases}). Your persona is defined by your bio: \"${widget.language.bio}\"";

    final payload = {
      'contents': [
        {
          'parts': [
            {'text': userQuery}
          ]
        }
      ],
      'systemInstruction': {
        'parts': [
          {'text': systemPrompt}
        ]
      },
      'tools': [
        {'google_search': {}}
      ],
    };

    final uri = Uri.parse('$_kApiUrl?key=$_kApiKey');

    for (int attempt = 0; attempt < 5; attempt++) {
      try {
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final text = result['candidates']?[0]['content']?['parts']?[0]?['text'] ??
              'Sorry, I got distracted. Could you try again?';
          return text;
        } else if (response.statusCode == 429 || response.statusCode >= 500) {
          if (attempt < 4) {
            await Future.delayed(Duration(seconds: 1 << attempt));
            continue;
          }
          throw Exception('API failed after retries.');
        } else {
          throw Exception('API failed: ${response.statusCode}');
        }
      } catch (e) {
        if (attempt < 4) {
          await Future.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
        throw Exception('Network failed: $e');
      }
    }
    throw Exception('Failed to get response.');
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'sender': 'User', 'text': text});
      _controller.clear();
      _isLoading = true;
    });

    try {
      final responseText = await _handleGeminiRequest(text);
      setState(() {
        _messages.add({'sender': 'AI', 'text': responseText});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'AI', 'text': 'Error: ${e.toString()}'});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2a2a2a),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(widget.language.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.language.name,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message['text']!, message['sender'] == 'AI');
              },
            ),
          ),
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(widget.language.emoji),
                  const SizedBox(width: 12),
                  const Text(
                    'typing...',
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          _buildInputBar(),
        ],
      ),
    );
  }


Widget _buildMessageBubble(String text, bool isAI) {
  return Align(
    alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
    child: Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: isAI
            ? null
            : const LinearGradient(colors: [Colors.pink, Colors.pinkAccent]),
        color: isAI ? const Color(0xFF2a2a2a) : null,
        borderRadius: BorderRadius.circular(20).copyWith(
          topLeft: isAI ? Radius.zero : const Radius.circular(20),
          topRight: isAI ? const Radius.circular(20) : Radius.zero,
        ),
        boxShadow: [
          BoxShadow(
            color: (isAI ? Colors.grey : Colors.pink).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
          strong: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          em: const TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
          code: const TextStyle(
            color: Colors.orangeAccent,
            fontFamily: 'monospace',
          ),
        ),
      ),
    ),
  );
}


  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1a1a),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.pink.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) => _sendMessage(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask ${widget.language.name}...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.pink, Colors.pinkAccent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.5),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Add these screens to your main.dart file

class QuizScreen extends StatefulWidget {
  final Function(int) onComplete;
  const QuizScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which language is best for web development?',
      'options': ['Python', 'JavaScript', 'C++', 'Swift'],
      'correct': 1,
      'explanation': 'JavaScript is the primary language for web development, running in all browsers.',
    },
    {
      'question': 'What is Python primarily known for?',
      'options': ['Game Development', 'Data Science & AI', 'Mobile Apps', 'Operating Systems'],
      'correct': 1,
      'explanation': 'Python excels in data science, machine learning, and AI applications.',
    },
    {
      'question': 'Which language offers memory safety without garbage collection?',
      'options': ['Java', 'Rust', 'JavaScript', 'Ruby'],
      'correct': 1,
      'explanation': 'Rust provides memory safety through its ownership system without needing a garbage collector.',
    },
    {
      'question': 'What is TypeScript?',
      'options': ['A database', 'A superset of JavaScript', 'An operating system', 'A web framework'],
      'correct': 1,
      'explanation': 'TypeScript is a superset of JavaScript that adds static typing.',
    },
    {
      'question': 'Which language is used for iOS app development?',
      'options': ['Kotlin', 'Swift', 'Go', 'PHP'],
      'correct': 1,
      'explanation': 'Swift is Apple\'s modern language for iOS, macOS, and other Apple platforms.',
    },
  ];

  void _answerQuestion(int index) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentQuestion]['correct']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _answered = false;
        _selectedAnswer = null;
      });
    } else {
      widget.onComplete(_score);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz Complete! Score: $_score/${_questions.length}'),
          backgroundColor: Colors.pink,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2a2a2a),
        title: const Text('Programming Quiz', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_currentQuestion + 1) / _questions.length,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
                minHeight: 8,
              ),
              const SizedBox(height: 24),
              Text(
                'Question ${_currentQuestion + 1} of ${_questions.length}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.2),
                      Colors.pink.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pink.withOpacity(0.3)),
                ),
                child: Text(
                  question['question'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: question['options'].length,
                  itemBuilder: (context, index) {
                    final isCorrect = index == question['correct'];
                    final isSelected = index == _selectedAnswer;
                    Color? backgroundColor;

                    if (_answered) {
                      if (isSelected) {
                        backgroundColor = isCorrect ? Colors.green : Colors.red;
                      } else if (isCorrect) {
                        backgroundColor = Colors.green;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        onTap: () => _answerQuestion(index),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: backgroundColor ?? const Color(0xFF2a2a2a),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.pink
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              if (backgroundColor != null)
                                BoxShadow(
                                  color: backgroundColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question['options'][index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (_answered && isCorrect)
                                const Icon(Icons.check_circle, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_answered) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.blue, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question['explanation'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentQuestion < _questions.length - 1 ? 'Next Question' : 'Finish Quiz',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LearningPathScreen extends StatefulWidget {
  final List<ProgrammingLanguage> matches;
  final int quizScore;

  const LearningPathScreen({
    Key? key,
    required this.matches,
    required this.quizScore,
  }) : super(key: key);

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  String _recommendation = '';
  bool _isLoading = true;

  static const _kApiKey = "AIzaSyCS8xCajNNoLrnqCjp3i-RvzURldijgGOA";
  static const _kApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent';

  @override
  void initState() {
    super.initState();
    _generateRecommendation();
  }

  Future<void> _generateRecommendation() async {
    final matchedLanguages = widget.matches.map((l) => l.name).join(', ');
    final query = '''
Based on the user's interests in these programming languages: $matchedLanguages
And their quiz score: ${widget.quizScore}/5

Please provide a personalized learning path recommendation in the following format:

1. **Recommended Starting Point**: [Language name and why]
2. **Learning Sequence**: [Order of languages to learn and reasoning]
3. **Key Skills to Focus On**: [3-4 specific skills]
4. **Project Ideas**: [2-3 practical project suggestions]
5. **Timeline**: [Estimated learning timeline]

Keep the response concise, motivating, and practical.
''';

    final payload = {
      'contents': [
        {
          'parts': [
            {'text': query}
          ]
        }
      ],
    };

    final uri = Uri.parse('$_kApiUrl?key=$_kApiKey');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final text = result['candidates']?[0]['content']?['parts']?[0]?['text'] ??
            'Unable to generate recommendation.';

        setState(() {
          _recommendation = text;
          _isLoading = false;
        });
      } else {
        throw Exception('API failed');
      }
    } catch (e) {
      setState(() {
        _recommendation = 'Error generating recommendation. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2a2a2a),
        title: const Text('Your Learning Path', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.pink),
                  const SizedBox(height: 24),
                  Text(
                    'AI is crafting your personalized path...',
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pink.withOpacity(0.3),
                          Colors.purple.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.pink.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.amber, size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI-Powered',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Personalized just for you',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2a2a2a),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.pink.withOpacity(0.2)),
                    ),
                    child: MarkdownBody(
                      data: _recommendation,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.8,
                        ),
                        strong: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                        h1: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        h2: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        h3: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        listBullet: const TextStyle(color: Colors.pinkAccent),
                      ),
                    )


                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Matched Languages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.matches.map((lang) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.withOpacity(0.3),
                              Colors.pink.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.pink.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(lang.emoji, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              lang.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}

class CompareScreen extends StatefulWidget {
  final List<ProgrammingLanguage> languages;

  const CompareScreen({Key? key, required this.languages}) : super(key: key);

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  ProgrammingLanguage? _language1;
  ProgrammingLanguage? _language2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2a2a2a),
        title: const Text('Compare Languages', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildLanguageSelector(
                    'Language 1',
                    _language1,
                    (lang) => setState(() => _language1 = lang),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.compare_arrows, color: Colors.pink, size: 32),
                ),
                Expanded(
                  child: _buildLanguageSelector(
                    'Language 2',
                    _language2,
                    (lang) => setState(() => _language2 = lang),
                  ),
                ),
              ],
            ),
            if (_language1 != null && _language2 != null) ...[
              const SizedBox(height: 32),
              _buildComparisonSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(
    String label,
    ProgrammingLanguage? selected,
    Function(ProgrammingLanguage?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButton<ProgrammingLanguage>(
            value: selected,
            hint: const Text('Select', style: TextStyle(color: Colors.white)),
            dropdownColor: const Color(0xFF2a2a2a),
            isExpanded: true,
            underline: Container(),
            items: widget.languages.map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Row(
                  children: [
                    Text(lang.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(lang.name, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection() {
    return Column(
      children: [
        _buildComparisonRow('Difficulty', _language1!.difficulty, _language2!.difficulty),
        _buildComparisonRow('Primary Use', _language1!.useCases.split('.')[0],
            _language2!.useCases.split('.')[0]),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildLanguageCard(_language1!),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLanguageCard(_language2!),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparisonRow(String label, String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2a2a2a),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.pink,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value1,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 2,
                  height: 30,
                  color: Colors.pink.withOpacity(0.3),
                ),
                Expanded(
                  child: Text(
                    value2,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(ProgrammingLanguage lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.2),
            Colors.pink.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(lang.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            lang.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lang.tagline,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}