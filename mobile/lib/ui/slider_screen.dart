import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/websocket_client.dart';
import 'package:mobile/websocket_command.dart';

class SliderScreenWidget extends StatefulWidget {
  final String ipAddress;

  const SliderScreenWidget({super.key, required this.ipAddress});

  @override
  State<StatefulWidget> createState() {
    return SliderScreenWidgetState();
  }
}

class SliderScreenWidgetState extends State<SliderScreenWidget> {
  late WebSocketClient _websocketClient;
  double _sliderRight = 0.0;
  double _sliderLeft = 0.0;
  bool _cutter = false;


  @override
  void initState() {
    super.initState();
    _websocketClient = WebSocketClient(widget.ipAddress);
    _websocketClient.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              Positioned(
                top: 50.0,
                left: null,
                right: null,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Switch(
                    value: _cutter,
                    activeColor: Colors.green,
                    onChanged: (bool value) {
                      setState(() {
                        _cutter = value;
                      });
                    },
                  ),
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    slider((value) {
                      _sliderLeft = value;
                      sendValues();
                    }, _sliderLeft),
                    const Expanded(child: Spacer()),
                    slider((value) {
                      _sliderRight = value;
                      sendValues();
                    }, _sliderRight),
                  ]),
            ])),
      ),
    );
  }

  void sendValues() {
    _websocketClient.send(
      WebsocketCommand(
          type: WebsocketCommandType.MOTOR,
          left: _sliderRight.toInt(),
          right: _sliderLeft.toInt(),
          cutter: _cutter),
    );
  }

  Widget slider(Function action, double value) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Slider(
        value: value,
        min: -100.0,
        max: 100.0,
        divisions: 20,
        activeColor: Colors.purple.shade100,
        inactiveColor: Colors.purple.shade100,
        label: value.round().toString(),
        onChanged: (double value) {
          setState(() {
            action.call(value);
          });
        },
      ),
    );
  }
}
