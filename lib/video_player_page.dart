import 'package:flutter/material.dart';
import 'package:v_player/models/video_models.dart';
import 'package:video_player/video_player.dart';

// class VideoPlayerPage extends StatefulWidget {
//   const VideoPlayerPage({super.key});

//   @override
//   State<VideoPlayerPage> createState() => _VideoPlayerPageState();
// }

// class _VideoPlayerPageState extends State<VideoPlayerPage> {
//   late VideoPlayerController _controller ;
//   int currentVideoIndex = 0;
//   bool isLoading = true;
//   String errorMessage = '';
//   void _playVideo({
//     int index = 0,
//   }) {
//     if (index < 0 || index >= videos.length) {
//       return;
//     }
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     if (_controller != null) {
//       _controller.dispose();
//     }
//     _controller = VideoPlayerController.networkUrl(Uri.parse(videos[index].url))
//       ..addListener(() => setState(() {}))
//       ..setLooping(true)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       }).catchError((error) {
//         setState(() {
//           isLoading = false;
//           errorMessage = error.toString();
//         });
//       });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _playVideo(index: currentVideoIndex);
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: 300,
//             color: Colors.deepOrange,
//             child: isLoading
//                 ? const CircularProgressIndicator()
//                 : errorMessage.isNotEmpty
//                     ? Text('Error: $errorMessage')
//                     : _controller.value.isInitialized
//                         ? Column(
//                             children: [
//                               SizedBox(
//                                 height: 200,
//                                 child: VideoPlayer(_controller),
//                               ),
//                             ],
//                           )
//                         : const CircularProgressIndicator(),
//           ),
//           Expanded(
//               child: ListView.builder(
//             itemCount: videos.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     currentVideoIndex = index;
//                     _playVideo(index: index);
//                   });
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 100,
//                         width: 100,
//                         child: Image.network(
//                           videos[index].thumbnail,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       SizedBox(
//                         child: Text(videos[index].name),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ))
//         ],
//       ),
//     );
//   }
// }
class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  int currentVideoIndex = 0;
  bool isLoading = true;
  String errorMessage = '';

  void _playVideo({required int index}) {
    if (index < 0 || index >= videos.length) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    _controller = VideoPlayerController.networkUrl(Uri.parse(videos[index].url))
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
          _controller.play();
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
          errorMessage = error.toString();
        });
      });
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void initState() {
    super.initState();
    _playVideo(index: currentVideoIndex);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
            height: 300,
            color: Colors.deepOrange,
            child: isLoading
                ? const CircularProgressIndicator()
                : errorMessage.isNotEmpty
                    ? Text('Error: $errorMessage')
                    : _controller.value.isInitialized
                        ? Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: VideoPlayer(_controller),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: _controller,
                                    builder: (context, VideoPlayerValue value,
                                        child) {
                                      return Text(
                                        _videoDuration(value.position),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 20,
                                      child: VideoProgressIndicator(
                                        _controller,
                                        allowScrubbing: true,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 12),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _videoDuration(_controller.value.duration),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () => _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play(),
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              )
                            ],
                          )
                        : const CircularProgressIndicator(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentVideoIndex = index;
                            _playVideo(index: index);
                          });
                        },
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            videos[index].thumbnail,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(videos[index].name),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// https://www.youtube.com/watch?v=P3l9o31AoeQ&t=187s 
// video Tutorial