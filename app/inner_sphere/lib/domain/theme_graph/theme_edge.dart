class ThemeEdge {
  const ThemeEdge({
    required this.id,
    required this.themeAId,
    required this.themeBId,
    required this.coOccurrenceCount,
    required this.pastWeekCoOccurrenceCount,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
    this.lastCoOccurredAt,
  });

  final String id;
  final String themeAId;
  final String themeBId;
  final int coOccurrenceCount;
  final int pastWeekCoOccurrenceCount;
  final double weight;
  final DateTime? lastCoOccurredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}
