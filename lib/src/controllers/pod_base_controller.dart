part of 'pod_getx_video_controller.dart';
// ignore_for_file: prefer_final_fields

class _PodBaseController extends GetxController {
  ///main video controller
  VideoPlayerController? _videoCtr;

  ///
  late PodVideoPlayerType _videoPlayerType;

  bool isMute = false;
  FocusNode? keyboardFocusWeb;

  bool autoPlay = true;
  bool _isWebAutoPlayDone = false;

  ///
  PodVideoState _podVideoState = PodVideoState.loading;

  ///
  bool isWebPopupOverlayOpen = false;

  ///
  Duration _videoDuration = Duration.zero;

  Duration _videoPosition = Duration.zero;

  String _currentPaybackSpeed = '1x';

  bool? isVideoUiBinded;

  bool? wasVideoPlayingOnUiDispose;

  int doubleTapForwardSeconds = 10;
  String? playingVideoUrl;

  late BuildContext mainContext;
  late BuildContext fullScreenContext;

  // Zoom functionality
  double _videoZoomScale = 1.0;
  double get videoZoomScale => _videoZoomScale;
  static const double _minZoomScale = 0.5;
  static const double _maxZoomScale = 3.0;
  static const double _zoomStep = 0.25;

  ///**listners

  Future<void> videoListner() async {
    if (!_videoCtr!.value.isInitialized) {
      await _videoCtr!.initialize();
    }
    if (_videoCtr!.value.isInitialized) {
      // _listneToVideoState();
      _listneToVideoPosition();
      _listneToVolume();
      if (kIsWeb && autoPlay && isMute && !_isWebAutoPlayDone) _webAutoPlay();
    }
  }

  void _webAutoPlay() => _videoCtr!.setVolume(1);

  void _listneToVolume() {
    if (_videoCtr!.value.volume == 0) {
      if (!isMute) {
        isMute = true;
        update(['volume']);
        update(['update-all']);
      }
    } else {
      if (isMute) {
        isMute = false;
        update(['volume']);
        update(['update-all']);
      }
    }
  }

  // void _listneToVideoState() {
  //   podVideoStateChanger(
  //     _videoCtr!.value.isBuffering || !_videoCtr!.value.isInitialized
  //         ? PodVideoState.loading
  //         : _videoCtr!.value.isPlaying
  //             ? PodVideoState.playing
  //             : PodVideoState.paused,
  //   );
  // }

  ///updates state with id `_podVideoState`
  void podVideoStateChanger(PodVideoState? val, {bool updateUi = true}) {
    if (_podVideoState != (val ?? _podVideoState)) {
      _podVideoState = val ?? _podVideoState;
      if (updateUi) {
        update(['podVideoState']);
        update(['update-all']);
      }
    }
  }

  void _listneToVideoPosition() {
    if ((_videoCtr?.value.duration.inSeconds ?? Duration.zero.inSeconds) < 60) {
      _videoPosition = _videoCtr?.value.position ?? Duration.zero;
      update(['video-progress']);
      update(['update-all']);
    } else {
      if (_videoPosition.inSeconds !=
          (_videoCtr?.value.position ?? Duration.zero).inSeconds) {
        _videoPosition = _videoCtr?.value.position ?? Duration.zero;
        update(['video-progress']);
        update(['update-all']);
      }
    }
  }

  void keyboadListner() {
    if (keyboardFocusWeb != null && !keyboardFocusWeb!.hasFocus) {
      if (keyboardFocusWeb!.canRequestFocus) {
        keyboardFocusWeb!.requestFocus();
      }
    }
  }

  /// Zoom in the video
  void zoomIn() {
    if (_videoZoomScale < _maxZoomScale) {
      _videoZoomScale = (_videoZoomScale + _zoomStep).clamp(_minZoomScale, _maxZoomScale);
      update(['zoom']);
      update(['update-all']);
    }
  }

  /// Zoom out the video
  void zoomOut() {
    if (_videoZoomScale > _minZoomScale) {
      _videoZoomScale = (_videoZoomScale - _zoomStep).clamp(_minZoomScale, _maxZoomScale);
      update(['zoom']);
      update(['update-all']);
    }
  }

  /// Reset zoom to default (1.0)
  void resetZoom() {
    _videoZoomScale = 1.0;
    update(['zoom']);
    update(['update-all']);
  }

  /// Set specific zoom scale
  void setZoomScale(double scale) {
    _videoZoomScale = scale.clamp(_minZoomScale, _maxZoomScale);
    update(['zoom']);
    update(['update-all']);
  }

  /// Toggle between zoom levels (1.0x, 1.5x, 2.0x)
  void toggleZoom() {
    if (_videoZoomScale == 1.0) {
      _videoZoomScale = 1.5;
    } else if (_videoZoomScale == 1.5) {
      _videoZoomScale = 2.0;
    } else {
      _videoZoomScale = 1.0;
    }
    update(['zoom']);
    update(['update-all']);
  }

  // void keyboadFullScreenListner() {
  //   print(keyboardFocusOnFullScreen?.hasFocus);
  //   if (keyboardFocusOnFullScreen != null &&
  //       !keyboardFocusOnFullScreen!.hasFocus) {
  //     if (keyboardFocusOnFullScreen!.canRequestFocus) {
  //       keyboardFocusOnFullScreen!.requestFocus();
  //     }
  //   }
  // }
}
