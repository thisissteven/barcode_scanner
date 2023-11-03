import 'package:barcode_scanner/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const borderPrimary = Color.fromARGB(255, 226, 232, 240);
const contentPrimary = Color.fromARGB(255, 30, 41, 59);

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Barcode",
                      style: TextStyle(
                        color: contentPrimary,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    SvgPicture.asset(
                      "assets/asterisk.svg",
                      width: 14,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                RawMaterialButton(
                  onPressed: () async {
                    String? value = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const QRViewDialog(),
                      ),
                    );

                    setState(() {
                      barcode = value ?? "";
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: const BorderSide(
                      color: borderPrimary,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          barcode,
                          style: const TextStyle(
                            color: contentPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SvgPicture.asset(
                        "assets/barcode-scan.svg",
                        width: 24,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
