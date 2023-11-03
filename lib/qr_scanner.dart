import 'dart:typed_data';

import 'package:barcode_scanner/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ToggleButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltipText;
  const ToggleButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.tooltipText});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltipText,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 36,
        height: 36,
        child: RawMaterialButton(
          onPressed: widget.onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(
              color: borderPrimary,
              width: 0.6,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class QRViewDialog extends StatefulWidget {
  const QRViewDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewDialogState();
}

class _QRViewDialogState extends State<QRViewDialog> {
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  controller: cameraController,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        Navigator.of(context).pop(barcode.rawValue);
                        break;
                      }
                    }
                  },
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: Colors.black.withOpacity(0.8), width: 80)),
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomPaint(
                          painter: MyCustomPainter(),
                          size: const Size(
                            250,
                            250,
                          ), // Set the size to match the container
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ToggleButton(
                        tooltipText: "Toggle Flashlight",
                        child: ValueListenableBuilder(
                          valueListenable: cameraController.torchState,
                          builder: (context, state, child) {
                            switch (state) {
                              case TorchState.off:
                                return SvgPicture.asset(
                                  "assets/no-flash.svg",
                                  width: 16,
                                );
                              case TorchState.on:
                                return SvgPicture.asset(
                                  "assets/flash.svg",
                                  width: 16,
                                );
                            }
                          },
                        ),
                        onPressed: () => cameraController.toggleTorch(),
                      ),
                      ToggleButton(
                        tooltipText: "Switch Camera",
                        onPressed: () => cameraController.switchCamera(),
                        child: ValueListenableBuilder(
                          valueListenable: cameraController.cameraFacingState,
                          builder: (context, state, child) {
                            return SvgPicture.asset(
                              "assets/switch-camera.svg",
                              width: 16,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    double lineSize = 60;
    double squareLength = size.width;

    // top left
    canvas.drawLine(
      Offset(0, 0),
      Offset(lineSize, 0),
      paint,
    );

    canvas.drawLine(
      Offset(0, 0),
      Offset(0, lineSize),
      paint,
    );

    // top right
    canvas.drawLine(
      Offset(squareLength, 0),
      Offset(squareLength - lineSize, 0),
      paint,
    );

    canvas.drawLine(
      Offset(squareLength, 0),
      Offset(squareLength, lineSize),
      paint,
    );

    // bottom left
    canvas.drawLine(
      Offset(0, squareLength),
      Offset(lineSize, squareLength),
      paint,
    );

    canvas.drawLine(
      Offset(0, squareLength),
      Offset(0, squareLength - lineSize),
      paint,
    );

    // bottom right
    canvas.drawLine(
      Offset(squareLength, squareLength),
      Offset(squareLength, squareLength - lineSize),
      paint,
    );

    canvas.drawLine(
      Offset(squareLength, squareLength),
      Offset(squareLength - lineSize, squareLength),
      paint,
    );

    // Uncomment the following lines if you want to draw circles at the corners
    // canvas.drawCircle(Offset(0, 0), paint.strokeWidth / 2, paint);
    // canvas.drawCircle(Offset(squareLength, 0), paint.strokeWidth / 2, paint);
    // canvas.drawCircle(Offset(0, squareLength), paint.strokeWidth / 2, paint);
    // canvas.drawCircle(Offset(squareLength, squareLength), paint.strokeWidth / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
