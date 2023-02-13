part of '../bloc/nodemcu_home_automation_bloc.dart';

class NodeMCUService {
  Future<void> initWebSocket(WebSocketChannel ws,
      void Function(Map<String, dynamic>) onDataReceive) async {
    late String data;
    await ws.ready.timeout(const Duration(seconds: 2));
    ws.sink.add('getState');
    ws.stream.listen((message) {
      debugPrint(message.toString());
      data = message;
      onDataReceive(jsonDecode(data));
    });
  }

  Future<void> sendToNodeMCU(String data, WebSocketChannel ws) async {
    ws.sink.add(data);
  }

  Future<void> closeWebSocket(WebSocketChannel ws) async {
    ws.sink.close();
  }
}
