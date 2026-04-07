import 'dart:math' as math;

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../domain/theme_graph/theme_edge.dart';
import '../../domain/theme_graph/theme_graph_repository.dart';
import '../../domain/theme_graph/theme_mention.dart';
import '../../domain/theme_graph/theme_node.dart';
import '../db/app_database.dart';

class LocalThemeGraphRepository implements ThemeGraphRepository {
  LocalThemeGraphRepository();

  final _uuid = const Uuid();

  Future<Database> get _db async => AppDatabase.open();

  @override
  Future<List<ThemeNode>> allNodes() async {
    final rows = await (await _db).query('theme_nodes', orderBy: 'weight DESC');
    return rows.map(_nodeFromRow).toList();
  }

  @override
  Future<List<ThemeEdge>> allEdges() async {
    final rows = await (await _db).query('theme_edges', orderBy: 'weight DESC');
    return rows.map(_edgeFromRow).toList();
  }

  @override
  Future<ThemeNode> upsertNodeFromMention(String canonicalTheme, DateTime at) async {
    final db = await _db;
    final existing = await db.query(
      'theme_nodes',
      where: 'canonical_name = ?',
      whereArgs: [canonicalTheme],
      limit: 1,
    );

    if (existing.isEmpty) {
      final id = _uuid.v4();
      final row = {
        'id': id,
        'canonical_name': canonicalTheme,
        'display_name': canonicalTheme,
        'total_mentions': 1,
        'past_week_mentions': 1,
        'weight': _weight(1, 1),
        'last_mentioned_at': at.toIso8601String(),
        'created_at': at.toIso8601String(),
        'updated_at': at.toIso8601String(),
      };
      await db.insert('theme_nodes', row);
      return _nodeFromRow(row);
    }

    final current = existing.first;
    final nodeId = current['id'] as String;
    final total = (current['total_mentions'] as int) + 1;
    final pastWeek = await countMentionsPastWeek(nodeId, at) + 1;
    await db.update(
      'theme_nodes',
      {
        'total_mentions': total,
        'past_week_mentions': pastWeek,
        'weight': _weight(total, pastWeek),
        'last_mentioned_at': at.toIso8601String(),
        'updated_at': at.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [nodeId],
    );

    return _nodeFromRow((await db.query('theme_nodes', where: 'id=?', whereArgs: [nodeId])).first);
  }

  @override
  Future<void> saveMentions(List<ThemeMention> mentions) async {
    final batch = (await _db).batch();
    for (final mention in mentions) {
      batch.insert('theme_mentions', {
        'id': mention.id,
        'voice_note_id': mention.voiceNoteId,
        'transcript_segment_id': mention.transcriptSegmentId,
        'theme_node_id': mention.themeNodeId,
        'raw_phrase': mention.rawPhrase,
        'normalized_phrase': mention.normalizedPhrase,
        'mention_score': mention.mentionScore,
        'created_at': mention.createdAt.toIso8601String(),
      });
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateEdgesForMentions(List<String> themeNodeIds, DateTime at) async {
    final db = await _db;
    final unique = themeNodeIds.toSet().toList()..sort();
    for (var i = 0; i < unique.length; i++) {
      for (var j = i + 1; j < unique.length; j++) {
        final a = unique[i];
        final b = unique[j];
        final existing = await db.query(
          'theme_edges',
          where: 'theme_a_id = ? AND theme_b_id = ?',
          whereArgs: [a, b],
          limit: 1,
        );
        if (existing.isEmpty) {
          await db.insert('theme_edges', {
            'id': _uuid.v4(),
            'theme_a_id': a,
            'theme_b_id': b,
            'co_occurrence_count': 1,
            'past_week_co_occurrence_count': 1,
            'weight': _weight(1, 1),
            'last_co_occurred_at': at.toIso8601String(),
            'created_at': at.toIso8601String(),
            'updated_at': at.toIso8601String(),
          });
        } else {
          final row = existing.first;
          final count = (row['co_occurrence_count'] as int) + 1;
          final week = await _countEdgePastWeek(a, b, at) + 1;
          await db.update(
            'theme_edges',
            {
              'co_occurrence_count': count,
              'past_week_co_occurrence_count': week,
              'weight': _weight(count, week),
              'last_co_occurred_at': at.toIso8601String(),
              'updated_at': at.toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [row['id']],
          );
        }
      }
    }
  }

  @override
  Future<int> countMentionsPastWeek(String themeNodeId, DateTime now) async {
    final weekAgo = now.subtract(const Duration(days: 7)).toIso8601String();
    final rows = await (await _db).rawQuery(
      'SELECT COUNT(*) AS c FROM theme_mentions WHERE theme_node_id = ? AND created_at >= ?',
      [themeNodeId, weekAgo],
    );
    return (rows.first['c'] as int?) ?? 0;
  }

  Future<int> _countEdgePastWeek(String a, String b, DateTime now) async {
    final weekAgo = now.subtract(const Duration(days: 7)).toIso8601String();
    final rows = await (await _db).rawQuery(
      'SELECT COUNT(*) AS c FROM theme_edges WHERE theme_a_id = ? AND theme_b_id = ? AND updated_at >= ?',
      [a, b, weekAgo],
    );
    return (rows.first['c'] as int?) ?? 0;
  }

  @override
  Future<List<ThemeConnection>> strongestConnections(String themeNodeId, {int limit = 5}) async {
    final db = await _db;
    final rows = await db.rawQuery(
      '''
      SELECT te.*, tn.id AS node_id, tn.canonical_name, tn.display_name, tn.total_mentions,
             tn.past_week_mentions, tn.weight AS node_weight, tn.last_mentioned_at,
             tn.created_at AS node_created_at, tn.updated_at AS node_updated_at
      FROM theme_edges te
      JOIN theme_nodes tn ON tn.id = CASE WHEN te.theme_a_id = ? THEN te.theme_b_id ELSE te.theme_a_id END
      WHERE te.theme_a_id = ? OR te.theme_b_id = ?
      ORDER BY te.weight DESC
      LIMIT ?
      ''',
      [themeNodeId, themeNodeId, themeNodeId, limit],
    );

    return rows
        .map(
          (row) => ThemeConnection(
            node: ThemeNode(
              id: row['node_id'] as String,
              canonicalName: row['canonical_name'] as String,
              displayName: row['display_name'] as String,
              totalMentions: row['total_mentions'] as int,
              pastWeekMentions: row['past_week_mentions'] as int,
              weight: row['node_weight'] as double,
              lastMentionedAt: _parseNullable(row['last_mentioned_at'] as String?),
              createdAt: DateTime.parse(row['node_created_at'] as String),
              updatedAt: DateTime.parse(row['node_updated_at'] as String),
            ),
            edge: _edgeFromRow(row),
          ),
        )
        .toList();
  }

  double _weight(int total, int weekly) => math.log(1 + total) + (0.12 * weekly);

  ThemeNode _nodeFromRow(Map<String, Object?> row) => ThemeNode(
        id: row['id'] as String,
        canonicalName: row['canonical_name'] as String,
        displayName: row['display_name'] as String,
        totalMentions: row['total_mentions'] as int,
        pastWeekMentions: row['past_week_mentions'] as int,
        weight: (row['weight'] as num).toDouble(),
        lastMentionedAt: _parseNullable(row['last_mentioned_at'] as String?),
        createdAt: DateTime.parse(row['created_at'] as String),
        updatedAt: DateTime.parse(row['updated_at'] as String),
      );

  ThemeEdge _edgeFromRow(Map<String, Object?> row) => ThemeEdge(
        id: row['id'] as String,
        themeAId: row['theme_a_id'] as String,
        themeBId: row['theme_b_id'] as String,
        coOccurrenceCount: row['co_occurrence_count'] as int,
        pastWeekCoOccurrenceCount: row['past_week_co_occurrence_count'] as int,
        weight: (row['weight'] as num).toDouble(),
        lastCoOccurredAt: _parseNullable(row['last_co_occurred_at'] as String?),
        createdAt: DateTime.parse(row['created_at'] as String),
        updatedAt: DateTime.parse(row['updated_at'] as String),
      );

  DateTime? _parseNullable(String? input) => input == null ? null : DateTime.parse(input);
}
