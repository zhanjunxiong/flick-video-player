import 'package:example/animation_player/portrait_video_controls.dart';
import 'package:example/utils/mock_data.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:video_player/video_player.dart';

class CustomFitPlayer extends StatefulWidget {
  CustomFitPlayer({Key key}) : super(key: key);

  @override
  _CustomFitPlayerState createState() => _CustomFitPlayerState();
}

class _CustomFitPlayerState extends State<CustomFitPlayer> {
  FlickManager flickManager;

  String url = mockData['items'][0]['trailer_url'];
  BoxFit fit = BoxFit.fitHeight;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(url),
        onVideoEnd: () {
          flickManager.flickControlManager.replay();
        });
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager.autoResume();
        }
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: FlickVideoPlayer(
                key: ValueKey(fit),
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  videoFit: fit,
                  controls: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: FlickToggleSoundAction(
                          child: FlickSeekVideoAction(
                            child: Center(child: FlickVideoBuffer()),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlickAutoHideChild(
                              autoHide: false,
                              showIfVideoNotInitialized: false,
                              child: FlickSoundToggle(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  controls: Container(),
                ),
              ),
            ),
            Wrap(
              children: BoxFit.values
                  .map(
                    (value) => GestureDetector(
                      onTap: () {
                        setState(() {
                          fit = value;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        color: value == fit ? Colors.green : Colors.grey,
                        child: Text(value.toString()),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
