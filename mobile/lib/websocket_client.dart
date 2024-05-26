import 'dart:async';
import 'package:fpv_lawn_mover/websocket_command.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  WebSocketChannel? _channel = null;
  String _ipAddress = "";



  void connect() async {
    try {
      print("connect");
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://$_ipAddress:8765'),
      );
      _listen();
    } catch (error) {
      print("Caught");
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() async {
    print("reconnect");
    await Future.delayed(const Duration(seconds: 1));
    connect();
  }

  WebSocketClient._privateConstructor();

  static final WebSocketClient _instance =
      WebSocketClient._privateConstructor();

  factory WebSocketClient(String ipAddress) {
    _instance._ipAddress = ipAddress;
    return _instance;
  }

  Future<void> send(WebsocketCommand command) async {
    var channel = _channel;
    if (channel != null) {
      await channel.ready;
      channel.sink.add(command.toJson());
    }
  }

  void _listen() async {
    var channel = _channel;
    if (channel != null) {
      await channel.ready;
      channel.stream.listen((message) {
        if (message == "PING" || message == "ping") {
          channel.sink.add('pong');
        }
      });
    }
  }
}
