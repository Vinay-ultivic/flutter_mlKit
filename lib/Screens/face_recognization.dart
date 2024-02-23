import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceScreen extends StatefulWidget {
  const FaceScreen({super.key});

  @override
  State<FaceScreen> createState() => _FaceScreenState();
}

class _FaceScreenState extends State<FaceScreen> {
  XFile? _image;

  void getImage(ImageSource source) async {
    try {
      XFile? pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {

        _image = pickedImage;
        setState(() {});

      }
    } catch (e) {

    }
  }
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image!=null ?
            Image.file(File(_image!.path)):const Icon(Icons.image,size: 50,),
            SizedBox(height: 20,),
            Center(
              child: SizedBox(
                height: size.height/16,
                width: size.width/1.6,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),

                    ),
                    backgroundColor:Colors.black,
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.normal),
                  ),
                  onPressed: () {
                  getImage(ImageSource.gallery);

                  },onLongPress: (){
                    getImage(ImageSource.camera);
                }
                  , child: const Text('Choose/Capture Face ',style:
                TextStyle(fontSize: 15,fontFamily: 'MarkPro',letterSpacing: 1,fontWeight: FontWeight.w700,color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
