import 'dart:convert' as convert;

enum WebsocketCommandType {
  MOTOR,
}

class WebsocketCommand {
  final WebsocketCommandType type;
  final int left;
  final int right;
  final bool cutter;

  const WebsocketCommand({
    required this.type,
    required this.left,
    required this.right,
    required this.cutter,
  });

  String toJson() {
    return convert.jsonEncode({
      'type': type.name.toUpperCase(),
      'left': left,
      'right': right,
      'cutter': cutter,
    });
  }
}