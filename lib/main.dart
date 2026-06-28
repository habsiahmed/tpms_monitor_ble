import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() => runApp(const TPMSApp());

class TPMSApp extends StatelessWidget {
  const TPMSApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TPMSHomePage());
  }
}

class TPMSHomePage extends StatefulWidget {
  const TPMSHomePage({super.key});

  @override
  State<TPMSHomePage> createState() => _TPMSHomePageState();
}

class _TPMSHomePageState extends State<TPMSHomePage> {
  List<String> foundDevices = [];

  void startScan() {
    // Start scanning for 15 seconds
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    // Listen to results and update the UI
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        String name = r.device.platformName.isEmpty ? "Unknown Device" : r.device.platformName;
        if (!foundDevices.contains(name)) {
          setState(() {
            foundDevices.add(name);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TPMS Sensor Reader")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: startScan,
              child: const Text("Start Scanning"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: foundDevices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(foundDevices[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}