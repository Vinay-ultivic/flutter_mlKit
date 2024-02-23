import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import '../../main.dart';
import '../../main.dart';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
var recog;
List recognize=[];
String result="";
CameraController? cameraController;
bool isDetecting=false;

@override
  void initState() {
  super.initState();

  if (cameras == null || cameras?.isEmpty==true) {
    log('No camera is found');
  }
  else{
    cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      cameraController?.startImageStream((CameraImage img) {
        if (!isDetecting) {
          isDetecting = true;
           Tflite.detectObjectOnFrame(
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            model: "SSDMobileNet",
            imageHeight: img.height,
            imageWidth: img.width,
            imageMean: 127.5,
            imageStd:  127.5,
            numResultsPerClass: 1,
            threshold:  0.4,


          ).then((recognitions) {
            result="";
          log("-----Reorganizations-----$recognitions");
          recognize.add(recognitions);

        /* recognize.firstWhere((re) => re.detectedClass == );*/

          log("-----length----${recognize.length}");
            isDetecting = false;
          });
        }
      });
    });
  }

  }


@override
void dispose() {
cameraController?.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        cameraController?.value.isInitialized==true ?
        CameraPreview(cameraController!) : const Center(child: Text("Camera is not loading....")),



      ],),
    );
  }
}

