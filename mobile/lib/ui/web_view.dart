import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final String url;
  const WebView({super.key, required this.url});

  @override
  State<WebView> createState() {
    return WebViewState(url: url);
  }
}

class WebViewState extends State<WebView> {
  late WebViewController _controller;
  final String url;

  WebViewState({required this.url});

  Future<WebViewController> initializePlayer() async {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    return _controller;
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializePlayer(),
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (data != null) {
          return WebViewWidget(controller: data);
        } else {
          return const Text("Waiting");
        }
      },
    );
  }
}
