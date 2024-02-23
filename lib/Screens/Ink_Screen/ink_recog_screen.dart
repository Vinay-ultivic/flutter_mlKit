import 'package:flutter/material.dart' hide Ink;



class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  InkController controller = InkController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Ink Recognition ')),
      body: SafeArea(
        child: Column(
          children: [
            const Text("Start writing below :"),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: GestureDetector(
                  onPanStart: (DragStartDetails details) {
                    controller.ink.strokes.add(Stroke());
                    setState(() {});
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    final RenderObject? object =
                    context.findRenderObject();
                    final localPosition = (object as RenderBox?)
                        ?.globalToLocal(details.localPosition);
                    if (localPosition != null) {
                      controller.points = List.from(controller.points)
                        ..add(StrokePoint(
                          x: localPosition.dx,
                          y: localPosition.dy,
                          t: DateTime.now().millisecondsSinceEpoch,
                        ));
                    }
                    if (controller.ink.strokes.isNotEmpty) {
                      controller.ink.strokes.last.points =
                          controller.points.toList();
                    }
                    setState(() {});
                  },
                  onPanEnd: (DragEndDetails details) {
                    controller.points.clear();
                  },
                  child: CustomPaint(
                    painter: Signature(ink: controller.ink),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
            if (controller.recognizedText.isNotEmpty)
              Container(
                margin: EdgeInsets.all(7),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                ),
                child: Center(
                  child: Text(
                    'Candidates: ${controller.recognizedText}',
                    style: TextStyle(fontSize: 23),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          child: Text('Read Text'),
                          onPressed: controller.recogniseText,
                        ),
                        ElevatedButton(
                          child: Text('Clear Pad'),
                          onPressed: controller.clearPad,
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InkController {
  String languageCode="";
  InkModel ink = InkModel();
  List<StrokePoint> points = [];
  String recognizedText = '';

  void recogniseText()async {

  }

  void clearPad() {
    ink = InkModel();
    points.clear();
    recognizedText = '';
    setState(() {});
  }



  void setState(VoidCallback callback) {
    callback();
  }
}

class InkModel {
  List<Stroke> strokes = [];
}

class Stroke {
  List<StrokePoint> points = [];
}

class StrokePoint {
  double x;
  double y;
  int t;

  StrokePoint({required this.x, required this.y, required this.t});
}






class Signature extends CustomPainter {
  final InkModel ink;

  Signature({required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in ink.strokes) {
      if (stroke.points.length > 1) {
        for (int i = 0; i < stroke.points.length - 1; i++) {
          Paint paint = Paint()
            ..color = Colors.black
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 5.0;
          canvas.drawLine(
            Offset(stroke.points[i].x, stroke.points[i].y),
            Offset(stroke.points[i + 1].x, stroke.points[i + 1].y),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

