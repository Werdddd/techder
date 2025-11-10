import 'package:flutter/material.dart';
import 'languages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// Removed, as randomness is now handled by unique static strings

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
  // Active tag filters for the Matches tab
  final Set<String> _activeTagFilters = {};

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
          // Filter chips based on tags found in the current matches
          if (_matches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // build chips from unique tags in matches (includes Easy/Normal/Hard)
                  ..._availableMatchTags().map((tag) {
                    final selected = _activeTagFilters.contains(tag);
                    return FilterChip(
                      label: Text(tag, style: const TextStyle(color: Colors.white)),
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
                  // Clear filters chip
                  if (_activeTagFilters.isNotEmpty)
                    ActionChip(
                      label: const Text('Clear'),
                      onPressed: () => setState(() => _activeTagFilters.clear()),
                      backgroundColor: Colors.grey[700],
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
          // Apply active tag filters to the matches list
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
                    'No matching Language',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                  childAspectRatio: 0.85,
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

  // Collect unique tags from the current matches list
  List<String> _availableMatchTags() {
    final tags = <String>{};
    for (final m in _matches) {
      tags.addAll(m.tags);
    }
    // Always include difficulty levels even if not present in matches
    tags.addAll(['Easy', 'Normal', 'Hard']);
    final list = tags.toList()..sort((a, b) {
      // Keep difficulties grouped and predictable: Easy, Normal, Hard first
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

// New widget to build a section that contains a numbered list (roadmap)
Widget _buildListSection(String title, List<String> items) {
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
          ...items.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$index.',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF2a2a2a),
        // Set AppBar title text color to white
        title: Text(
          language.name,
          style: const TextStyle(color: Colors.white),
        ),
        // Set leading icon (back button) color to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
            // NEW ROADMAP SECTION
            _buildListSection(
              'Your 5-Step Roadmap',
              language.roadmap,
            ),
            // END NEW ROADMAP SECTION
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
      // NEW: Floating Action Button to start the chat
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
        icon: const Icon(Icons.chat),
        backgroundColor: Colors.pink,
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
          }).toList(),
        ],
      ),
    );
  }
}

// --- NEW CHAT SCREEN IMPLEMENTATION ---

class ChatScreen extends StatefulWidget {
  final ProgrammingLanguage language;
  const ChatScreen({Key? key, required this.language}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  // Messages stored as map: {'sender': 'User' or 'AI', 'text': 'message'}
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // --- API Configuration ---
  // NOTE: You must replace "" with your actual API key
  static const _kApiKey = "AIzaSyCS8xCajNNoLrnqCjp3i-RvzURldijgGOA"; 
  static const _kApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent';
  // --- End API Configuration ---

  // Removed: List of potential chat starters with placeholders (_chatStarters)

  @override
  void initState() {
    super.initState();
    
    // Updated: Directly use the unique, personalized chat string stored in the language model
    final initialMessage = widget.language.initialChat;

    // Initial engaging message from the "language" persona
    _messages.add({
      'sender': 'AI',
      'text': initialMessage,
    });
  }

  Future<String> _handleGeminiRequest(String userQuery) async {
    // 1. Construct the System Prompt
    final systemPrompt =
        "Act as you are in a dating app. You are the ${widget.language.name} Programming Language. Your responses should be playful, engaging, and based on your core features and use cases (${widget.language.useCases}). Your persona is defined by your bio: \"${widget.language.bio}\"";

    // 2. Construct the API Payload
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
      // Enable Google Search for grounded responses
      'tools': [
        {'google_search': {}}
      ],
    };

    // 3. Prepare URL and perform request with exponential backoff
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
          // Safely extract the generated text
          final text = result['candidates']?[0]['content']?['parts']?[0]?['text'] ??
              'Sorry, I got distracted by a shiny new feature. Could you try again?';
          
          return text;
        } else if (response.statusCode == 429 || response.statusCode >= 500) {
          // Handle rate limiting (429) or server errors (5xx) with backoff
          if (attempt < 4) {
            await Future.delayed(Duration(seconds: 1 << attempt));
            continue; // Retry the request
          }
          throw Exception('API failed after multiple retries.');
        } else {
          // Handle non-retriable client errors (4xx)
          throw Exception('API failed with status ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        // Handle network errors or decoding errors
        if (attempt < 4) {
            await Future.delayed(Duration(seconds: 1 << attempt));
            continue; // Retry the request
        }
        throw Exception('Network request failed: $e');
      }
    }
    // Should be unreachable, but here for completeness
    throw Exception('Failed to get a response from the API.');
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;
    if (_kApiKey.isEmpty) {
       _messages.add({'sender': 'AI', 'text': 'ERROR: The API Key is empty. Please add your Gemini API Key to the `_kApiKey` constant in main.dart to enable the chat.'});
       setState(() {});
       return;
    }

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
      // Show error in the chat bubble
      setState(() {
        _messages.add({'sender': 'AI', 'text': 'Error communicating with the AI: ${e.toString()}'});
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
        // Set AppBar title text color to white
        title: Text(
          'Chatting with ${widget.language.name}',
          style: const TextStyle(color: Colors.white),
        ),
        // Set leading icon (back button) color to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(color: Colors.pink),
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
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isAI ? const Color(0xFF2a2a2a) : Colors.pink,
          borderRadius: BorderRadius.circular(16.0).copyWith(
            topLeft: isAI ? Radius.zero : const Radius.circular(16.0),
            topRight: isAI ? const Radius.circular(16.0) : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: (isAI ? Colors.grey : Colors.pink).withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(color: isAI ? Colors.white : Colors.white),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xFF2a2a2a),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (value) => _sendMessage(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ask ${widget.language.name} about a project...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: const Color(0xFF1a1a1a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
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