import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:video_player_web_hls/src/video_player.dart';

import 'shims/dart_ui.dart' as ui;

class HtmlVideoPlayerView extends StatefulWidget {
  HtmlVideoPlayerView({
    Key? key,
    required this.videoPlayer,
  }) : super(key: key);

  final VideoPlayer videoPlayer;

  @override
  _HtmlVideoPlayerViewState createState() => _HtmlVideoPlayerViewState();
}

class _HtmlVideoPlayerViewState extends State<HtmlVideoPlayerView> {
  late final VideoElement _videoElement;

  String get _viewType => 'videoPlayer-${identityHashCode(this)}';

  @override
  void initState() {
    super.initState();
    _videoElement = VideoElement()
      ..id = 'videoElement-${identityHashCode(this)}'
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%'
      ..muted = true
      ..autoplay = true
      ..controls = false
      ..srcObject = widget.videoPlayer.captureMediaStream();
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _videoElement,
    );
  }

  @override
  void didUpdateWidget(HtmlVideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPlayer != oldWidget.videoPlayer) {
      ui.platformViewRegistry.registerViewFactory(
        _viewType,
        (int viewId) => _videoElement,
      );

      _videoElement.srcObject = widget.videoPlayer.captureMediaStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
