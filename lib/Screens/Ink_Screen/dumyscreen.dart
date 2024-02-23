import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class DumyScreen extends StatefulWidget {
  const DumyScreen({super.key});

  @override
  _DumyScreenState createState() => _DumyScreenState();
}

class _DumyScreenState extends State<DumyScreen> {
  List<Offset> points = [];
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  bool isRecognizing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Ink Recognition'),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              points.add(details.globalPosition);
            });
          },
          onPanEnd: (_) {
            recognizeDigitalInk();
          },
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: CustomPaint(
              painter: MyPainter(points),
            ),
          ),
        ),
      ),
    );
  }

  void recognizeDigitalInk() async {
    setState(() {
      isRecognizing = true;
    });

    try {
      InputImage inputImage = InputImage.fromFilePath("https://plus.unsplash.com/premium_photo-1669324357471-e33e71e3f3d8?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"); // Provide a fake path for text detection

      final recognisedText = await textRecognizer.processImage(inputImage);

      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            print(element.text);
          }
        }
      }
    } catch (e) {
      print('Error recognizing digital ink: $e');
    }

    setState(() {
      isRecognizing = false;
    });
  }
}






class MyPainter extends CustomPainter {
  final List<Offset> points;

  MyPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
