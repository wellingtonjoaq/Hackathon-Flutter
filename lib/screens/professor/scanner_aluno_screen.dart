import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerAlunoScreen extends StatefulWidget {
  const ScannerAlunoScreen({super.key});

  @override
  State<ScannerAlunoScreen> createState() => _ScannerAlunoScreenState();
}

class _ScannerAlunoScreenState extends State<ScannerAlunoScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanned = false;

  @override
  void reassemble() {
    super.reassemble();
    // Para corrigir problemas de câmera quando muda o estado da app
    if (controller != null) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      if (!scanned) {
        scanned = true;
        controller.pauseCamera();
        Navigator.pop(context, scanData.code); // Volta para tela anterior enviando o código escaneado
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Aluno'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blueAccent,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 8,
          cutOutSize: 250,
        ),
      ),
    );
  }
}
