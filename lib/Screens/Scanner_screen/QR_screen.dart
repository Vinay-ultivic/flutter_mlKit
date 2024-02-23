import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.black),),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(),
              SizedBox(
                height: 300,
                width: 300,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Container(
                child: Center(
                  child: (result != null)
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          'Barcode Type: ${result!.format}',style: TextStyle(fontWeight:FontWeight.w300,fontSize: 20,color: Colors.black)),
                          Text("Data: ${result!.code}",style: TextStyle(fontWeight:FontWeight.w300,fontSize: 20,color: Colors.black))


                        ],
                      )
                      : const Text('Scan a code',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.black),),
                ),
              ),const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}





