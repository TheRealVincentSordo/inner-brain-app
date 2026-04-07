import 'package:uuid/uuid.dart';

import '../../domain/theme_graph/theme_graph_repository.dart';
import '../../domain/theme_graph/theme_mention.dart';
import 'theme_extractor.dart';

class UpdateThemeGraphUseCase {
  UpdateThemeGraphUseCase(this._repository, this._extractor);

  final ThemeGraphRepository _repository;
  final ThemeExtractor _extractor;
  final _uuid = const Uuid();

  Future<List<String>> call({
    required String text,
    String? voiceNoteId,
    String? transcriptSegmentId,
    DateTime? at,
  }) async {
    final when = at ?? DateTime.now();
    final hits = _extractor.extract(text);
    final mentions = <ThemeMention>[];
    final nodeIds = <String>[];

    for (final hit in hits) {
      final node = await _repository.upsertNodeFromMention(hit.canonical, when);
      nodeIds.add(node.id);
      mentions.add(
        ThemeMention(
          id: _uuid.v4(),
          voiceNoteId: voiceNoteId,
          transcriptSegmentId: transcriptSegmentId,
          themeNodeId: node.id,
          rawPhrase: hit.raw,
          normalizedPhrase: hit.canonical,
          mentionScore: hit.score,
          createdAt: when,
        ),
      );
    }

    if (mentions.isNotEmpty) {
      await _repository.saveMentions(mentions);
      await _repository.updateEdgesForMentions(nodeIds, when);
    }

    return hits.map((e) => e.canonical).toList();
  }
}
