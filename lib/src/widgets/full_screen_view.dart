part of 'package:pod_player/src/pod_player.dart';

/// A custom widget that supports pinch-to-zoom, pan and rotation.
/// This widget listens to scale gestures and applies a combined transformation.
class ZoomableRotatable extends StatefulWidget {
  final Widget child;
  const ZoomableRotatable({required this.child, Key? key}) : super(key: key);

  @override
  _ZoomableRotatableState createState() => _ZoomableRotatableState();
}

class _ZoomableRotatableState extends State<ZoomableRotatable> {
  // Variables to store current transformation values.
  double _scale = 1.0;
  double _rotation = 0.0;
  Offset _offset = Offset.zero;

  // Variables for storing initial state values when a gesture starts.
  double _initialScale = 1.0;
  double _initialRotation = 0.0;
  Offset _initialOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // When a new gesture starts, record the current values.
      onScaleStart: (ScaleStartDetails details) {
        _initialScale = _scale;
        _initialRotation = _rotation;
        _initialOffset = _offset;
      },
      // Update scale, rotation and translation based on the gesture updates.
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          // Multiply the initial scale by the gesture scale factor.
          _scale = _initialScale * details.scale;
          // Increment the initial rotation by the gesture rotation (in radians).
          _rotation = _initialRotation + details.rotation;
          // Update the translation (panning) with the change in focal point.
          _offset = _initialOffset + details.focalPointDelta;
        });
      },
      child: Transform.translate(
        offset: _offset,
        child: Transform.rotate(
          angle: _rotation,
          child: Transform.scale(
            scale: _scale,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// The full screen view that now supports zoom, pan, and rotation.
class FullScreenView extends StatefulWidget {
  final String tag;
  const FullScreenView({
    required this.tag,
    super.key,
  });

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView>
    with TickerProviderStateMixin {
  late PodGetXVideoController _podCtr;
  @override
  void initState() {
    _podCtr = Get.find<PodGetXVideoController>(tag: widget.tag);
    _podCtr.fullScreenContext = context;
    _podCtr.keyboardFocusWeb?.removeListener(_podCtr.keyboadListner);
    super.initState();
  }

  @override
  void dispose() {
    _podCtr.keyboardFocusWeb?.requestFocus();
    _podCtr.keyboardFocusWeb?.addListener(_podCtr.keyboadListner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingWidget = _podCtr.onLoading?.call(context) ??
        const CircularProgressIndicator(
          backgroundColor: Colors.black87,
          color: Colors.white,
          strokeWidth: 2,
        );

    return WillPopScope(
      onWillPop: () async {
        if (kIsWeb) {
          await _podCtr.disableFullScreen(
            context,
            widget.tag,
            enablePop: false,
          );
        }
        if (!kIsWeb) await _podCtr.disableFullScreen(context, widget.tag);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GetBuilder<PodGetXVideoController>(
          tag: widget.tag,
          builder: (podCtr) => Center(
            child: ColoredBox(
              color: Colors.black,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: podCtr.videoCtr == null
                      ? loadingWidget
                      : podCtr.videoCtr!.value.isInitialized
                          ? ZoomableRotatable(
                              child: _PodCoreVideoPlayer(
                                tag: widget.tag,
                                videoPlayerCtr: podCtr.videoCtr!,
                                videoAspectRatio:
                                    podCtr.videoCtr?.value.aspectRatio ?? 16 / 9,
                              ),
                            )
                          : loadingWidget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
