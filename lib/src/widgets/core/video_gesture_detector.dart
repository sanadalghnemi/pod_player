part of 'package:pod_player/src/pod_player.dart';

class _VideoGestureDetector extends StatefulWidget {
  final Widget? child;
  final void Function()? onDoubleTap;
  final void Function()? onTap;
  final String tag;

  const _VideoGestureDetector({
    required this.tag,
    this.child,
    this.onDoubleTap,
    this.onTap,
  });

  @override
  State<_VideoGestureDetector> createState() => _VideoGestureDetectorState();
}

class _VideoGestureDetectorState extends State<_VideoGestureDetector> {
  double _baseScaleFactor = 1;
  Timer? _gestureTimer;


  @override
  void dispose() {
    _gestureTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>(tag: widget.tag);
    
    return MouseRegion(
      onHover: (event) => podCtr.onOverlayHover(),
      onExit: (event) => podCtr.onOverlayHoverExit(),
      child: GestureDetector(
        onTap: widget.onTap ?? podCtr.toggleVideoOverlay,
        onDoubleTap: widget.onDoubleTap,
        onScaleStart: (details) {
          _baseScaleFactor = podCtr.videoZoomScale;
          
          // Only hide overlay if this is a multi-finger gesture (zoom/pan)
          if (details.pointerCount > 1) {
            podCtr.isShowOverlay(false);
            _gestureTimer?.cancel();
          }
        },
        onScaleUpdate: (details) {
          if (details.pointerCount == 2 && details.scale != 1) {
            // Pinch to zoom with two fingers
            final newScale = (_baseScaleFactor * details.scale)
                .clamp(0.5, 3.0);
            
            podCtr.setZoomScale(newScale);
            
            // Update pan offset based on focal point
            if (newScale > 1) {
              podCtr.setPanOffset(details.focalPoint);
            }
          } else if (details.pointerCount == 1 && podCtr.videoZoomScale > 1) {
            // Single finger pan when zoomed in
            podCtr.updatePanOffset(details.focalPointDelta);
          }
        },
        onScaleEnd: (details) {
          // Only show overlay again if this was a multi-finger gesture
          if (details.pointerCount > 1 || podCtr.videoZoomScale > 1) {
            _gestureTimer = Timer(const Duration(milliseconds: 1000), () {
              if (mounted) {
                podCtr.isShowOverlay(true);
              }
            });
          }
        },
        child: widget.child,
      ),
    );
  }
}
