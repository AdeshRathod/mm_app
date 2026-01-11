import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:app/core/Server.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  WebSocketChannel? _channel;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  bool _isConnected = false;

  void connect(String userId) {
    if (_isConnected) return;

    final url = "${Server().api.socketUrl}/api/v1/chat/ws/$userId";
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _isConnected = true;

    _channel!.stream.listen(
      (data) {
        final decoded = json.decode(data);
        _messageController.add(decoded);
      },
      onDone: () {
        _isConnected = false;
        print("WebSocket Disconnected");
      },
      onError: (error) {
        _isConnected = false;
        print("WebSocket Error: $error");
      },
    );
  }

  void sendMessage(Map<String, dynamic> msg) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(json.encode(msg));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }
}
