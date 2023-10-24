import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const DigitalSignageApp());
}

class DigitalSignageApp extends StatelessWidget {
  const DigitalSignageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DigitalSignagePlayer(),
    );
  }
}

class DigitalSignagePlayer extends StatefulWidget {
  const DigitalSignagePlayer({Key? key}) : super(key: key);

  @override
  DigitalSignagePlayerState createState() => DigitalSignagePlayerState();
}

class DigitalSignagePlayerState extends State<DigitalSignagePlayer> {
  final String apiEndpoint =
      'https://fast-crag-45759.herokuapp.com/api/pelis'; // URL de la API que proporciona los recursos
  List<String> mediaPaths = [];
  VideoPlayerController? videoPlayerController;
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchMediaPaths();
    _startTimer();
  }

  @override
  void dispose() {
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _fetchMediaPaths() async {
    final response = await http.get(Uri.parse(apiEndpoint));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<String> paths =
          data.map<String>((media) => media['cover']).toList();

      setState(() {
        mediaPaths = paths;
        _currentIndex = 0; // Reiniciar el índice al obtener nuevos datos
        if (videoPlayerController != null) {
          videoPlayerController!.dispose();
        }
        _initializeMedia();
      });
    }
  }

  void _initializeMedia() {
    final mediaPath = mediaPaths[_currentIndex];
    if (mediaPath.endsWith('.mp4')) {
      videoPlayerController = VideoPlayerController.network(mediaPath)
        ..initialize().then((_) {
          videoPlayerController!.play();
          setState(() {});
        });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % mediaPaths.length;
        _initializeMedia();
      });
    });
  }

  void _updateMediaPaths() {
    _fetchMediaPaths();
  }

  @override
  Widget build(BuildContext context) {
    if (mediaPaths.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final mediaPath =
        _currentIndex < mediaPaths.length ? mediaPaths[_currentIndex] : '';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (mediaPath.endsWith('.png'))
            AutoZoomImageFade(
              imagePath: mediaPath,
            ),
          if (mediaPath.endsWith('.mp4'))
            AspectRatio(
              aspectRatio: videoPlayerController?.value.aspectRatio ?? 16 / 9,
              child: VideoPlayer(videoPlayerController!),
            ),
          const Positioned(
            top: 16.0,
            left: 16.0,
            child: Text(
              'Digital Signage Player',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateMediaPaths,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class AutoZoomImageFade extends StatefulWidget {
  final String imagePath;

  const AutoZoomImageFade({Key? key, required this.imagePath})
      : super(key: key);

  @override
  AutoZoomImageFadeState createState() => AutoZoomImageFadeState();
}

class AutoZoomImageFadeState extends State<AutoZoomImageFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_controller);
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            color: Colors.black,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Image.network(widget.imagePath),
              ),
            ),
          );
        },
      ),
    );
  }
}
