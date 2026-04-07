class ThemeNode {
  const ThemeNode({
    required this.id,
    required this.canonicalName,
    required this.displayName,
    required this.totalMentions,
    required this.pastWeekMentions,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
    this.lastMentionedAt,
  });

  final String id;
  final String canonicalName;
  final String displayName;
  final int totalMentions;
  final int pastWeekMentions;
  final double weight;
  final DateTime? lastMentionedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}
