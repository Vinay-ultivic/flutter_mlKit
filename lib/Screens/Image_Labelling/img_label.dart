import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelScreen extends StatefulWidget {
  const ImageLabelScreen({super.key});

  @override
  State<ImageLabelScreen> createState() => _ImageLabelScreenState();
}

class _ImageLabelScreenState extends State<ImageLabelScreen> {
  bool textScanning = false;
  XFile? imageFile;
  String text = "";



  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(" Image Labelling "),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageFile==null?
                    Container(
                      width:size.width/1.3,
                      height: size.height/2.9,
                      color: Colors.grey[300]!,
                      child: const Center(child: Text("No Image Selected",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: Colors.black),)),
                    ):
                    Center(child: Image.file(File(imageFile!.path),height: size.height/2.9,width: size.width/1.3,)),

                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height / 16,
                          width: size.width / 2.7,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),),
                                backgroundColor: Colors.white,
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal),
                              ),
                              onPressed: () {
                                getImage(ImageSource.gallery);

                              }, child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.photo_album,color: Colors.black,),
                              Text('Gallery', style:
                              TextStyle(fontSize: 15,
                                  fontFamily: 'MarkPro',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),),
                              SizedBox(),
                            ],)
                          ),
                        ),
                        const SizedBox(width: 15,),
                        SizedBox(
                          height: size.height / 16,
                          width: size.width / 2.7,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),

                                ),
                                backgroundColor: Colors.white,
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal),
                              ),
                              onPressed: () {
                                getImage(ImageSource.camera);

                              }, child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.camera_alt_outlined,color: Colors.black,),
                              Text('Camera', style:
                              TextStyle(fontSize: 15,
                                  fontFamily: 'MarkPro',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),),
                              SizedBox(),
                            ],)
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Column(
                      children: [
                        const Text("Recognition Labels: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),),
                        Container(
                          child:  textScanning ? const CircularProgressIndicator(color: Colors.black,):Text(
                            text,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          )),
    );
  }

  void getImage(ImageSource source) async {
    try {
      XFile? pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getImageLabelling();
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      text = "Error occurred while scanning";
      setState(() {});
    }
  }

  void getImageLabelling() async {
    setState(() {
      textScanning=true;
    });
    try {
      final inputImage = InputImage.fromFilePath(imageFile!.path);
      final imageLabeler = GoogleMlKit.vision.imageLabeler();
      final List labels = await imageLabeler.processImage(inputImage);

  StringBuffer sb =StringBuffer();
    for (var imgLabel in labels) {
      String lblText=imgLabel.label;
      double confidence=imgLabel.confidence;

      sb.write(lblText);
      sb.write(" : ");
      sb.write((confidence*100).toStringAsFixed(2));
      sb.write("%\n");

      /*text ='${imgLabel.label} (${(imgLabel.confidence*100).toStringAsFixed(2)}%)\n';*/
      }
      imageLabeler.close();
    text=sb.toString();
      textScanning=false;
    setState(() {
    });

    }


    catch(e){

    }

  }
}
