import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  // A callback to notify when a new message is received
  Function(String message)? onMessageReceived;

  void connect() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Connected');
    });

    socket.onDisconnect((_) {
      print('Disconnected');
    });

    // Listen for incoming messages
    socket.on('receive_message', (data) {
      onMessageReceived?.call(data);
    });
  }

  // Method to send messages
  void sendMessage(String message) {
    socket.emit('send_message', message);
  }
}
