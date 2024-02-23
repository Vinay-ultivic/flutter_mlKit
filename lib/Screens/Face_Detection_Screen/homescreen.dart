
import 'package:flutter/material.dart';
import 'package:mlkit_project/Screens/Face_Detection_Screen/face_detect.dart';
import 'package:mlkit_project/Screens/Text_Recognize_Screen/text_Recognizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Image.asset("assets/images/logo.png",height: size.height/2.4,width: size.width/1.7,),
            Column(children: [
              Column(children: [
                SizedBox(
                  height: size.height/16,
                  width: size.width/1.6,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),

                      ),
                      backgroundColor:Colors.blue,
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal),
                    ),
                    onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FaceDetectScreen()));

                    },
                    child: const Text(' Face Recognize ',style:
                    TextStyle(fontSize: 15,fontFamily: 'MarkPro',letterSpacing: 1,fontWeight: FontWeight.w700,color: Colors.white),),
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: size.height/16,
                  width: size.width/1.6,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor:Colors.blue,
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal),
                    ),
                    onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const TextScreen()));

                    },
                    child: const Text('Text Recognize ',style:
                    TextStyle(fontSize: 15,fontFamily: 'MarkPro',letterSpacing: 1,fontWeight: FontWeight.w700,color: Colors.white),),
                  ),
                ),
              ],)

            ],)
          ],),
        ),
      ),
    );
  }
}
