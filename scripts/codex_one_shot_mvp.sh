#!/usr/bin/env bash
set -euo pipefail

# One-shot MVP bootstrap for InnerSphere.
# Usage:
#   bash scripts/codex_one_shot_mvp.sh
#   bash scripts/codex_one_shot_mvp.sh --run

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$PROJECT_ROOT/app/inner_sphere"
RUN_AFTER_SETUP="false"

for arg in "$@"; do
  if [[ "$arg" == "--run" ]]; then
    RUN_AFTER_SETUP="true"
  fi
done

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[ERROR] Missing required command: $cmd"
    exit 1
  fi
}

echo "[1/7] Checking prerequisites..."
require_cmd flutter
require_cmd dart
require_cmd git

echo "[2/7] Creating Flutter app (if missing)..."
if [[ ! -d "$APP_DIR" ]]; then
  mkdir -p "$(dirname "$APP_DIR")"
  flutter create \
    --org com.innersphere \
    --project-name inner_sphere \
    --platforms android,ios \
    "$APP_DIR"
else
  echo "      App already exists at $APP_DIR (skipping create)."
fi

cd "$APP_DIR"

echo "[3/7] Adding core MVP dependencies..."
flutter pub add flutter_riverpod sqflite path path_provider collection vector_math

echo "[4/7] Creating clean architecture directories..."
mkdir -p lib/{presentation,application,domain,data}/
mkdir -p lib/presentation/{screens,widgets,state}
mkdir -p lib/application/use_cases
mkdir -p lib/domain/{entities,repositories,services}
mkdir -p lib/data/{repositories,models,adapters,storage}
mkdir -p lib/features/{voice_note,transcript,theme_graph,follow_up}

echo "[5/7] Writing MVP starter files..."
cat > lib/main.dart <<'DART'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: InnerSphereApp()));
}

class InnerSphereApp extends StatelessWidget {
  const InnerSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnerSphere',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('InnerSphere MVP')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Local-first reflective app scaffold is ready.\n\n'
            'Next: implement voice note capture, native transcript bridge, '
            'theme extraction, and 3D sphere rendering.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
DART

cat > lib/domain/entities/voice_note.dart <<'DART'
class VoiceNote {
  VoiceNote({
    required this.id,
    required this.createdAt,
    required this.audioFilePath,
    required this.durationMs,
  });

  final String id;
  final DateTime createdAt;
  final String audioFilePath;
  final int durationMs;
}
DART

cat > lib/domain/entities/theme_node.dart <<'DART'
class ThemeNode {
  ThemeNode({
    required this.id,
    required this.canonicalName,
    required this.weight,
    required this.pastWeekMentions,
  });

  final String id;
  final String canonicalName;
  final double weight;
  final int pastWeekMentions;
}
DART

cat > lib/domain/entities/theme_edge.dart <<'DART'
class ThemeEdge {
  ThemeEdge({
    required this.id,
    required this.themeAId,
    required this.themeBId,
    required this.weight,
  });

  final String id;
  final String themeAId;
  final String themeBId;
  final double weight;
}
DART

cat > lib/data/adapters/transcription_bridge.dart <<'DART'
import 'package:flutter/services.dart';

class TranscriptionBridge {
  static const MethodChannel _channel = MethodChannel('innersphere/transcription');

  Future<bool> isOnDeviceTranscriptionAvailable({required String locale}) async {
    final result = await _channel.invokeMethod<bool>(
      'isOnDeviceTranscriptionAvailable',
      {'locale': locale},
    );
    return result ?? false;
  }

  Future<String> transcribeAudio({required String filePath, required String locale}) async {
    final result = await _channel.invokeMethod<String>(
      'transcribeAudio',
      {'filePath': filePath, 'locale': locale},
    );
    return result ?? '';
  }
}
DART

cat > lib/application/use_cases/extract_themes_use_case.dart <<'DART'
class ExtractThemesUseCase {
  /// Lightweight local tagging placeholder for MVP.
  /// Replace with deterministic phrase/tag rules aligned to docs.
  List<String> call(String transcript) {
    final normalized = transcript.toLowerCase();
    final themes = <String>{};

    if (normalized.contains('work') || normalized.contains('job')) {
      themes.add('work pressure');
    }
    if (normalized.contains('family') || normalized.contains('parent')) {
      themes.add('family');
    }
    if (normalized.contains('anxious') || normalized.contains('anxiety')) {
      themes.add('anxiety');
    }

    if (themes.isEmpty && normalized.trim().isNotEmpty) {
      themes.add('general reflection');
    }

    return themes.toList(growable: false);
  }
}
DART

cat > lib/presentation/screens/graph_screen.dart <<'DART'
import 'package:flutter/material.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('3D sphere graph placeholder (MVP milestone 3).'),
    );
  }
}
DART

echo "[6/7] Formatting and static check..."
dart format lib
flutter analyze

echo "[7/7] Setup complete."
if [[ "$RUN_AFTER_SETUP" == "true" ]]; then
  echo "Launching app..."
  flutter run
else
  cat <<MSG

Next steps:
  1) cd app/inner_sphere
  2) flutter pub get
  3) flutter run

Use '--run' to launch automatically after setup.
MSG
fi
