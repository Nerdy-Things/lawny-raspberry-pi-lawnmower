import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpv_lawn_mover/ui/main_widget.dart';
import 'package:fpv_lawn_mover/ui/slider_screen.dart';
import 'package:fpv_lawn_mover/ui/web_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String _ipAddress = "192.168.8.198";

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WakelockPlus.enable();
    return MaterialApp(
      title: 'Lawny',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Stack(
        children: [
          WebView(url: "http://$_ipAddress:8888/cam1"),
          ControlWidget(
            ipAddress: _ipAddress,
          ),
        ]
      ),
    );
  }
}
