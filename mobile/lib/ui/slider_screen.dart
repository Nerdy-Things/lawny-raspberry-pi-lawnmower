import 'package:flutter/material.dart';
import 'package:fpv_lawn_mover/websocket_client.dart';
import 'package:fpv_lawn_mover/websocket_command.dart';

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
  double _sliderVertical = 0.0;
  double _sliderHorizontal = 0.0;
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
              SizedBox(
                height: 100.0,
                width: double.infinity,
                child: Center(
                  child: Switch(
                    value: _cutter,
                    activeColor: Colors.green,
                    onChanged: (bool value) {
                      setState(() {
                        _cutter = value;
                        sendValues();
                      });
                    },
                  ),
                ),
              ),
              Column(children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: slider(true, (value) {
                      _sliderVertical = value;
                      sendValues();
                    }, _sliderVertical),
                  ),
                ),
                slider(false, (value) {
                  _sliderHorizontal = value;
                  sendValues();
                }, _sliderHorizontal),
                // const Expanded(child: Spacer()),
              ]),
            ])),
      ),
    );
  }

  void sendValues() {
    _websocketClient.send(
      WebsocketCommand(
        type: WebsocketCommandType.MOTOR,
        x: _sliderHorizontal.toInt(),
        y: _sliderVertical.toInt(),
        cutter: _cutter,
      ),
    );
  }

  Widget slider(bool isVertical, Function action, double value) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: (isVertical) ? 50.0 : double.infinity,
        child: RotatedBox(
          quarterTurns: (isVertical) ? 3 : 2,
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
        ),
      ),
    );
  }
}
