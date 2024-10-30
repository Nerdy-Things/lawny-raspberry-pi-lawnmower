import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebView extends StatefulWidget {
  final String url;
  late final PlatformWebViewControllerCreationParams params;

  WebView({super.key, required this.url}) {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
  }

  @override
  State<WebView> createState() {
    return WebViewState(url: url, params: params);
  }
}

class WebViewState extends State<WebView> {
  late WebViewController _controller;
  final String url;
  final PlatformWebViewControllerCreationParams params;

  WebViewState({
    required this.url,
    required this.params,
  });

  Future<WebViewController> initializePlayer() async {
    _controller = WebViewController.fromPlatformCreationParams(params)
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
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
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
