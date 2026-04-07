class ThemeHit {
  const ThemeHit({required this.raw, required this.canonical, required this.score});

  final String raw;
  final String canonical;
  final double score;
}

class ThemeExtractor {
  static const Map<String, List<String>> _lexicon = {
    'work pressure': ['work', 'deadline', 'job', 'meeting', 'manager', 'burnout'],
    'relationships': ['friend', 'partner', 'family', 'conflict', 'connection'],
    'health': ['sleep', 'exercise', 'energy', 'health', 'tired'],
    'purpose': ['meaning', 'purpose', 'direction', 'future', 'goal'],
    'money': ['money', 'debt', 'finances', 'salary', 'cost'],
    'calm': ['calm', 'peace', 'grounded', 'relief', 'breathe'],
  };

  List<ThemeHit> extract(String content) {
    final normalized = content.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    final words = normalized.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final hits = <ThemeHit>[];

    for (final entry in _lexicon.entries) {
      final matched = words.where((word) => entry.value.contains(word)).toList();
      if (matched.isNotEmpty) {
        hits.add(
          ThemeHit(
            raw: matched.first,
            canonical: entry.key,
            score: (matched.length / entry.value.length).clamp(0.2, 1.0),
          ),
        );
      }
    }

    return hits;
  }
}
