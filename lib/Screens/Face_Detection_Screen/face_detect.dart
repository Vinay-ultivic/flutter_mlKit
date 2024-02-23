import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit_project/Screens/dummyfaceScreen.dart';

import 'painter_class.dart';

class FaceDetectScreen extends StatefulWidget {
  const FaceDetectScreen({super.key});

  @override
  State<FaceDetectScreen> createState() => _FaceDetectScreenState();
}

class _FaceDetectScreenState extends State<FaceDetectScreen> {

@override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  File? _image;
List<Face>? _faces;
ui.Image? images;
bool loading=false;

final faceDetector=GoogleMlKit.vision.faceDetector(FaceDetectorOptions(performanceMode: FaceDetectorMode.fast,enableLandmarks: true));

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          loading=true;
          _image = File(pickedImage.path);

          doFaceDetection();
        });

      }
    } catch (e) {

    }
  }

  doFaceDetection() async{
    setState(() {
      loading=true;
    });
    final inputImage = InputImage.fromFilePath(_image!.path);
    final faceDetector=GoogleMlKit.vision.faceDetector(FaceDetectorOptions(performanceMode: FaceDetectorMode.fast,enableLandmarks: true));
    final List<Face> faces = await faceDetector.processImage(inputImage);
    setState(() {
      _image;
      _faces = faces;
      _loadImage(_image!);
      loading=false;
    });

  }


@override
void dispose() {
  faceDetector.close();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Face Detection"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (_image != null && images != null && _faces != null)   ? FittedBox(
                    child: SizedBox(
                    width: images?.width.toDouble() ?? 100,
                    height: images?.height.toDouble() ?? 100,
                    child: CustomPaint(
                     painter: FacePainter(images!, _faces!),
                    ),
                  ),
                )
                    :
                Container(
                    height: size.height/1.9,
                    width: size.width/1,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.6),
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child:  const Center(child: Text("No Face Found",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.black),))),
            
            
                Column(children: [
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                   Card(
                     color: Colors.white,
                     shape: const RoundedRectangleBorder(
                         borderRadius: BorderRadius.all(Radius.circular(200))),
                     child: InkWell(
                       onTap: () {
                          getImage(ImageSource.gallery);
                       },
                       child: SizedBox(
                         width: size.width/3,
                         height: size.height/15  ,
                         child: const Icon(Icons.image,
                             color: Colors.blue, size: 40),
                       ),
                     ),
                   ),
                   Card(
                     color: Colors.white,
                     shape: const RoundedRectangleBorder(
                         borderRadius: BorderRadius.all(Radius.circular(200))),
                     child: InkWell(
                       onTap: () {
                    getImage(ImageSource.camera);
                       },
                       child: SizedBox(
                         width: size.width/3,
                         height: size.height/16  ,
                         child: const Icon(Icons.camera_alt_outlined,
                             color: Colors.blue, size: 40),
                       ),
                     ),
                   ),
                 ],)
            
                ],)
              ],),
          ),
        ),
      ),
    );
  }

_loadImage(File file) async {
  final data = await file.readAsBytes();
  await decodeImageFromList(data).then((value) =>
      setState(() {
    images = value;
  }));
}
}

