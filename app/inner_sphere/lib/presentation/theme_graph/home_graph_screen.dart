import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/theme_graph/theme_graph_repository.dart';
import '../../domain/theme_graph/theme_node.dart';
import '../shared/providers.dart';
import '../voice_note/record_voice_note_screen.dart';

class HomeGraphScreen extends ConsumerStatefulWidget {
  const HomeGraphScreen({super.key});

  @override
  ConsumerState<HomeGraphScreen> createState() => _HomeGraphScreenState();
}

class _HomeGraphScreenState extends ConsumerState<HomeGraphScreen> {
  double _rotationY = 0;
  double _rotationX = 0;
  List<ThemeNode> _nodes = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(themeGraphRepositoryProvider);
    final nodes = await repo.allNodes();
    if (mounted) setState(() => _nodes = nodes);
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(themeGraphRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('InnerSphere'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'A calm place to observe what is showing up lately.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _rotationY += details.delta.dx * 0.01;
                  _rotationX += details.delta.dy * 0.01;
                });
              },
              child: FutureBuilder<List<ThemeConnection>>(
                future: _nodes.isEmpty ? Future.value(const []) : repo.strongestConnections(_nodes.first.id),
                builder: (context, snapshot) {
                  final edges = snapshot.data ?? const [];
                  return CustomPaint(
                    painter: SphereGraphPainter(
                      nodes: _nodes,
                      edges: edges,
                      rotationX: _rotationX,
                      rotationY: _rotationY,
                    ),
                    child: Stack(
                      children: _buildNodeHitTargets(context, repo),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RecordVoiceNoteScreen()),
          );
          _load();
        },
        label: const Text('Record'),
        icon: const Icon(Icons.mic),
      ),
    );
  }

  List<Widget> _buildNodeHitTargets(BuildContext context, ThemeGraphRepository repo) {
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, (size.height - 140) / 2);
    const radius = 130.0;
    final widgets = <Widget>[];
    for (var i = 0; i < _nodes.length; i++) {
      final angle = (2 * math.pi * i) / (_nodes.length == 0 ? 1 : _nodes.length) + _rotationY;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle + _rotationX * 0.5);
      widgets.add(
        Positioned(
          left: x - 20,
          top: y - 20,
          child: GestureDetector(
            onLongPress: () async {
              final node = _nodes[i];
              final week = await repo.countMentionsPastWeek(node.id, DateTime.now());
              final connections = await repo.strongestConnections(node.id);
              if (!context.mounted) return;
              showModalBottomSheet<void>(
                context: context,
                builder: (_) => _NodeDetailOverlay(node: node, pastWeek: week, connections: connections),
              );
            },
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );
    }
    return widgets;
  }
}

class SphereGraphPainter extends CustomPainter {
  SphereGraphPainter({
    required this.nodes,
    required this.edges,
    required this.rotationX,
    required this.rotationY,
  });

  final List<ThemeNode> nodes;
  final List<ThemeConnection> edges;
  final double rotationX;
  final double rotationY;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const sphereRadius = 130.0;

    final spherePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white24;
    canvas.drawCircle(center, sphereRadius, spherePaint);

    for (var i = 0; i < nodes.length; i++) {
      final angle = (2 * math.pi * i) / (nodes.isEmpty ? 1 : nodes.length) + rotationY;
      final nodePos = Offset(
        center.dx + sphereRadius * math.cos(angle),
        center.dy + sphereRadius * math.sin(angle + rotationX * 0.5),
      );
      final intensity = (nodes[i].weight / 4).clamp(0.2, 1.0);
      canvas.drawCircle(
        nodePos,
        8 + (nodes[i].weight * 2),
        Paint()..color = Colors.blue.withOpacity(intensity.toDouble()),
      );
    }

    for (final connection in edges) {
      final a = nodes.indexWhere((n) => n.id == connection.edge.themeAId);
      final b = nodes.indexWhere((n) => n.id == connection.edge.themeBId);
      if (a == -1 || b == -1) continue;
      final aAngle = (2 * math.pi * a) / (nodes.isEmpty ? 1 : nodes.length) + rotationY;
      final bAngle = (2 * math.pi * b) / (nodes.isEmpty ? 1 : nodes.length) + rotationY;
      final aPos = Offset(center.dx + sphereRadius * math.cos(aAngle), center.dy + sphereRadius * math.sin(aAngle));
      final bPos = Offset(center.dx + sphereRadius * math.cos(bAngle), center.dy + sphereRadius * math.sin(bAngle));
      final t = (connection.edge.weight / 4).clamp(0.0, 1.0);
      canvas.drawLine(
        aPos,
        bPos,
        Paint()
          ..strokeWidth = 1 + connection.edge.weight
          ..color = Color.lerp(Colors.blue, Colors.red, t)!.withOpacity(0.75),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SphereGraphPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.edges != edges;
  }
}

class _NodeDetailOverlay extends StatelessWidget {
  const _NodeDetailOverlay({required this.node, required this.pastWeek, required this.connections});

  final ThemeNode node;
  final int pastWeek;
  final List<ThemeConnection> connections;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node.displayName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Mentions in past week: $pastWeek'),
            const SizedBox(height: 12),
            const Text('Strongest connections:'),
            ...connections.map(
              (c) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(c.node.displayName),
                trailing: Text(c.edge.weight.toStringAsFixed(2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
