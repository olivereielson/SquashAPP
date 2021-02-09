import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'main.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final bool showimg;
  final bool automl;
  final int start_camera;
  double threshold;

  Camera(this.cameras, this.setRecognitions, this.showimg, this.automl,this.start_camera);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  double xpos = 10;
  double ypos = 10;
  bool camera = true;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[widget.start_camera],
        ResolutionPreset.high,
      );

      controller.initialize().then((_) async {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) async {
          if (!isDetecting) {
            isDetecting = true;

            if (widget.automl) {
              Tflite.detectObjectOnFrame(
                      bytesList: img.planes.map((plane) {
                        return plane.bytes;
                      }).toList(),
                      imageHeight: img.height,
                      imageWidth: img.width,
                      model: "SSDMobileNet",
                      threshold: 0.01,


                      numResultsPerClass: 1)
                  .then((recognitions) {
                //print(recognitions);

                widget.setRecognitions(recognitions, img.height, img.width);
                isDetecting = false;
              });
            } else {
              Tflite.runPoseNetOnFrame(
                      bytesList: img.planes.map((plane) {
                        return plane.bytes;
                      }).toList(),
                      imageHeight: img.height,
                      imageWidth: img.width,
                      threshold: 0.8,

                numResults: 1
              )
                  .then((recognitions) {
                widget.setRecognitions(recognitions, img.height, img.width);

                print(recognitions);
                isDetecting = false;
              });
            }
          }
        });
      });
    }
  }


  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

// If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
    }

    if (mounted) {
      setState(() {});
    }
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    //tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Stack(
      children: <Widget>[
        Center(
          child: AspectRatio(
            aspectRatio: MediaQuery.of(context).size.width /
                MediaQuery.of(context).size.height,

            // Use the VideoPlayer widget to display the video.

            child: widget.showimg ? CameraPreview(controller) : Container(),
          ),
        ),

      ],
    );
  }
}
