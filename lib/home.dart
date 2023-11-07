import 'package:barcode_scanner/input_provider.dart';
import 'package:barcode_scanner/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

const borderPrimary = Color.fromARGB(255, 226, 232, 240);
const contentPrimary = Color.fromARGB(255, 30, 41, 59);

class HomePage extends StatefulWidget {
  final bool withAddButton;
  const HomePage({super.key, this.withAddButton = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> barcode = [""];

  void updateProvider() {
    if (mounted) {
      Provider.of<InputModel>(context, listen: false).setBarcode(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...List.generate(
        barcode.length,
        (index) {
          bool isFirstIndex = index == 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
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
                            barcode[index] = value ?? "";
                          });

                          updateProvider();
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
                                barcode[index],
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
                  ),
                ),
                if (!isFirstIndex)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 48,
                      child: RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            barcode.removeAt(index);
                          });

                          updateProvider();
                        },
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: const BorderSide(
                            color: borderPrimary,
                            width: 0.6,
                          ),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      if (widget.withAddButton) const SizedBox(height: 12),
      if (widget.withAddButton)
        SizedBox(
          width: double.infinity,
          child: RawMaterialButton(
            onPressed: () {
              setState(() {
                barcode.add("");
              });

              updateProvider();
            },
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            fillColor: Colors.teal.shade600,
            padding: const EdgeInsets.all(12),
            child: const Text(
              "Tambah",
              style: TextStyle(
                color: borderPrimary,
              ),
            ),
          ),
        ),
    ]);
  }
}
