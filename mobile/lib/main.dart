import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/ui/slider_screen.dart';
import 'package:mobile/ui/web_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  final String _ipAddress = "192.168.1.77";

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
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
            WebView(url: "http://$_ipAddress:8889/cam1"),
            SliderScreenWidget(ipAddress: _ipAddress),
          ]),
        ));
  }
}
