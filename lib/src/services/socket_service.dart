import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  // Function to connect to the socket server
  void connect() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Listen for typing and stop typing events
    socket.on('typing', (data) {
      if (onTyping != null) {
        onTyping!(data);
      }
    });

    socket.on('stopTyping', (data) {
      if (onStopTyping != null) {
        onStopTyping!(data);
      }
    });

    // Listen for incoming messages
    socket.on('receiveMessage', (data) {
      if (onMessageReceived != null) {
        onMessageReceived!(data);
      }
    });

    // Handle errors
    socket.on('error', (data) {
      print('Socket error: $data');
    });
  }

  // Function to send a message
  void sendMessage(
      String roomId,
      String senderId,
      String receiverId,
      String? content,
      String? media,
      String? senderName,
      String? receiverName,
      String? receiverAvatar) {
    socket.emit('sendMessage', {
      'room_id': roomId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'media': media,
      'sender_name': senderName,
      'receiver_name': receiverName,
      'receiver_avatar': receiverAvatar,
    });
  }

  void sendGroupMessage(
      String roomId, String senderId, String? content, String? media) {
    socket.emit('sendMessage', {
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'media': media,
    });
  }

  // Function to join a room
  void joinRoom(String roomId) {
    socket.emit('joinRoom', roomId);
  }

  // Functions for typing events
  void typing(String roomId) {
    socket.emit('typing', roomId);
  }

  void stopTyping(String roomId) {
    socket.emit('stopTyping', roomId);
  }

  // Event handlers
  Function(Map<String, dynamic>)? onMessageReceived;
  Function(Map<String, dynamic>)? onTyping;
  Function(Map<String, dynamic>)? onStopTyping;
}
