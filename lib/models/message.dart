/// Models an individual chat message.
class Message {
  final String sender; // Sender of the message, "AI" or "User"
  final String content; // Content of the message
  final DateTime timestamp; // Timestamp when the message was sent

  Message({
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  // TODO: Add fromJson and toJson methods if needed for persistence
  /*
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String), // Assuming ISO 8601 format
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  */
}