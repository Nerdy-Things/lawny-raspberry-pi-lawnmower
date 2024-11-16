import 'package:flutter/material.dart';
import 'package:fpv_lawn_mover/ui/slider_screen.dart';
import 'package:fpv_lawn_mover/ui/web_view.dart';
import 'package:fpv_lawn_mover/websocket_client.dart';
import 'package:fpv_lawn_mover/websocket_command.dart';

class ControlWidget extends StatefulWidget {
  final String ipAddress;

  const ControlWidget({super.key, required this.ipAddress});

  @override
  State<StatefulWidget> createState() {
    return ControlWidgetState();
  }
}

class ControlWidgetState extends State<ControlWidget> {
  var isVisible = true;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (isVisible) {
      icon = const Icon(Icons.remove_red_eye_rounded);
    } else {
      icon = const Icon(Icons.remove_red_eye_outlined);
    }
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
          Visibility(
            visible: isVisible,
            child: SliderScreenWidget(ipAddress: widget.ipAddress),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: IconButton(
                iconSize: 48,
                icon: icon,
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
            ),
          ),
        ]));
  }
}
