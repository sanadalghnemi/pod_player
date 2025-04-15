import 'package:flutter/services.dart';
part of 'package:pod_player/src/pod_player.dart';

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
    super.initState();
    // Allow fullscreen mode to support both portrait and landscape orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    _podCtr = Get.find<PodGetXVideoController>(tag: widget.tag);
    _podCtr.fullScreenContext = context;
    _podCtr.keyboardFocusWeb?.removeListener(_podCtr.keyboadListner);
  }
  
  @override
  void dispose() {
    // Reset to portrait orientation when leaving fullscreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
      child: OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: GetBuilder<PodGetXVideoController>(
              tag: widget.tag,
              builder: (podCtr) {
                final videoAspectRatio = podCtr.videoCtr?.value.aspectRatio ?? 16 / 9;
                final screenSize = MediaQuery.of(context).size;
                
                // Calculate the appropriate size based on orientation
                double width = screenSize.width;
                double height = screenSize.height;
                
                if (orientation == Orientation.landscape) {
                  // In landscape, we want to fill the screen width
                  height = width / videoAspectRatio;
                  if (height > screenSize.height) {
                    height = screenSize.height;
                    width = height * videoAspectRatio;
                  }
                } else {
                  // In portrait, we want to fill the screen height
                  width = height * videoAspectRatio;
                  if (width > screenSize.width) {
                    width = screenSize.width;
                    height = width / videoAspectRatio;
                  }
                }
                
                return Center(
                  child: ColoredBox(
                    color: Colors.black,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Center(
                        child: podCtr.videoCtr == null
                            ? loadingWidget
                            : podCtr.videoCtr!.value.isInitialized
                                ? _PodCoreVideoPlayer(
                                    tag: widget.tag,
                                    videoPlayerCtr: podCtr.videoCtr!,
                                    videoAspectRatio: videoAspectRatio,
                                  )
                                : loadingWidget,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
