import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _dbName = 'inner_sphere.db';
  static const _dbVersion = 1;

  static Future<Database> open() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      p.join(dbPath, _dbName),
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE voice_notes(
            id TEXT PRIMARY KEY,
            created_at TEXT NOT NULL,
            duration_ms INTEGER NOT NULL,
            audio_file_path TEXT NOT NULL,
            audio_format TEXT NOT NULL,
            transcription_status TEXT NOT NULL,
            source TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE transcript_segments(
            id TEXT PRIMARY KEY,
            voice_note_id TEXT NOT NULL,
            segment_index INTEGER NOT NULL,
            text TEXT NOT NULL,
            start_ms INTEGER,
            end_ms INTEGER,
            confidence REAL,
            created_at TEXT NOT NULL,
            FOREIGN KEY(voice_note_id) REFERENCES voice_notes(id)
          );
        ''');
        await db.execute('''
          CREATE TABLE theme_nodes(
            id TEXT PRIMARY KEY,
            canonical_name TEXT UNIQUE NOT NULL,
            display_name TEXT NOT NULL,
            total_mentions INTEGER NOT NULL,
            past_week_mentions INTEGER NOT NULL,
            weight REAL NOT NULL,
            last_mentioned_at TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE theme_mentions(
            id TEXT PRIMARY KEY,
            voice_note_id TEXT,
            transcript_segment_id TEXT,
            theme_node_id TEXT NOT NULL,
            raw_phrase TEXT NOT NULL,
            normalized_phrase TEXT NOT NULL,
            mention_score REAL NOT NULL,
            created_at TEXT NOT NULL,
            FOREIGN KEY(theme_node_id) REFERENCES theme_nodes(id)
          );
        ''');
        await db.execute('''
          CREATE TABLE theme_edges(
            id TEXT PRIMARY KEY,
            theme_a_id TEXT NOT NULL,
            theme_b_id TEXT NOT NULL,
            co_occurrence_count INTEGER NOT NULL,
            past_week_co_occurrence_count INTEGER NOT NULL,
            weight REAL NOT NULL,
            last_co_occurred_at TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            UNIQUE(theme_a_id, theme_b_id)
          );
        ''');
        await db.execute('''
          CREATE TABLE follow_up_prompts(
            id TEXT PRIMARY KEY,
            trigger_voice_note_id TEXT NOT NULL,
            prompt_text TEXT NOT NULL,
            prompt_type TEXT NOT NULL,
            shown_at TEXT NOT NULL,
            dismissed_at TEXT,
            created_at TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE follow_up_responses(
            id TEXT PRIMARY KEY,
            follow_up_prompt_id TEXT NOT NULL,
            response_type TEXT NOT NULL,
            text_content TEXT,
            voice_note_id TEXT,
            created_at TEXT NOT NULL,
            FOREIGN KEY(follow_up_prompt_id) REFERENCES follow_up_prompts(id)
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // MVP migration placeholder for future schema versions.
      },
    );
  }
}
