

import 'dart:async';

import 'package:chatgpt_app/screens/chat_screen.dart';
import 'package:chatgpt_app/screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late VideoPlayerController _videoPlayerController;
  bool _isVideoLoaded = false;

  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async{
    auth.authStateChanges().listen((User? user) {
      if(user != null && mounted){
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  late final AnimationController _controller =
  AnimationController(duration: Duration(seconds: 3), vsync: this)..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _videoPlayerController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLogin();
    Timer(
        const Duration(seconds: 5),
            () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => isLogin ? const ChatScreen() : const HomePage())));

    _videoPlayerController = VideoPlayerController.asset("assets/video/splash_video5.mp4")..initialize().then((value){
      setState(() {
        _isVideoLoaded = true;
      });
      _videoPlayerController.play();
    });
    _videoPlayerController.addListener(() {
      setState(() {
        if(_videoPlayerController.value.position == _videoPlayerController.value.duration){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => isLogin ? const ChatScreen() : const HomePage()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // AnimatedBuilder(
          //     animation: _controller,
          //     child: Container(
          //       height: 350,
          //       width:  350,
          //       child: const Center(
          //         child: Image(
          //           image: AssetImage('assets/images/ai.png'),
          //         ),
          //       ),
          //     ),
          //     builder: (BuildContext context, Widget? child) {
          //       return Transform.rotate(
          //           child: child, angle: _controller.value * 2.0 * math.pi);
          //     }),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(800),
              child: Container(
                width: 330,
                height: 330,
                child: _isVideoLoaded
                    ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                    : CircularProgressIndicator(),
              ),
            )
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'Welcome to',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .008,
                ),
                Text(
                  'Chatlingual',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


//Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image(
//               image: AssetImage("assets/images/ai.png")),
//           SizedBox(
//             height: height * .02,
//           ),
//           Text("Welcome to my Chatgpt", style: TextStyle(fontSize: 25, color: Colors.white),)
//         ],
//       ),