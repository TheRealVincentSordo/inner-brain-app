import 'theme_edge.dart';
import 'theme_mention.dart';
import 'theme_node.dart';

class ThemeConnection {
  const ThemeConnection({required this.node, required this.edge});

  final ThemeNode node;
  final ThemeEdge edge;
}

abstract class ThemeGraphRepository {
  Future<List<ThemeNode>> allNodes();
  Future<List<ThemeEdge>> allEdges();
  Future<ThemeNode> upsertNodeFromMention(String canonicalTheme, DateTime at);
  Future<void> saveMentions(List<ThemeMention> mentions);
  Future<void> updateEdgesForMentions(List<String> themeNodeIds, DateTime at);
  Future<int> countMentionsPastWeek(String themeNodeId, DateTime now);
  Future<List<ThemeConnection>> strongestConnections(String themeNodeId, {int limit = 5});
}
