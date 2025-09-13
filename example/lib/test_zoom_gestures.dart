import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class TestZoomGestures extends StatefulWidget {
  const TestZoomGestures({super.key});

  @override
  State<TestZoomGestures> createState() => _TestZoomGesturesState();
}

class _TestZoomGesturesState extends State<TestZoomGestures> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom & Pan Test'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PodVideoPlayer(controller: controller),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• Pinch with two fingers to zoom in/out'),
                const Text('• Pan with one finger when zoomed in'),
                const Text('• Use zoom buttons for precise control'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => controller.zoomOut(),
                      child: const Text('Zoom Out'),
                    ),
                    ElevatedButton(
                      onPressed: () => controller.resetZoom(),
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: () => controller.zoomIn(),
                      child: const Text('Zoom In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}