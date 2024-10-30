import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpv_lawn_mover/ui/slider_screen.dart';
import 'package:fpv_lawn_mover/ui/web_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String _ipAddress = "192.168.8.162";

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WakelockPlus.enable();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(children: [
            Container(
              color: Colors.blueAccent,
            ),
            Positioned.fill(
              child: WebView(url: "http://$_ipAddress:8888/cam1"),
            ),
            SliderScreenWidget(ipAddress: _ipAddress),
            // WebView(url: "http://$_ipAddress:8888/cam1"),
          ]),
        ));
  }
}
