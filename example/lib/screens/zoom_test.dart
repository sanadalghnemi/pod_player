import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';

class ZoomTestScreen extends StatefulWidget {
  const ZoomTestScreen({Key? key}) : super(key: key);

  @override
  State<ZoomTestScreen> createState() => _ZoomTestScreenState();
}

class _ZoomTestScreenState extends State<ZoomTestScreen> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
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
        title: const Text('Zoom Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () => controller.zoomOut(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.resetZoom(),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () => controller.zoomIn(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            PodVideoPlayer(controller: controller),
            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => controller.setZoomScale(0.5),
                  child: const Text('0.5x'),
                ),
                ElevatedButton(
                  onPressed: () => controller.setZoomScale(1.0),
                  child: const Text('1.0x'),
                ),
                ElevatedButton(
                  onPressed: () => controller.setZoomScale(1.5),
                  child: const Text('1.5x'),
                ),
                ElevatedButton(
                  onPressed: () => controller.setZoomScale(2.0),
                  child: const Text('2.0x'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => controller.toggleZoom(),
              child: const Text('Toggle Zoom'),
            ),
          ],
        ),
      ),
    );
  }
}