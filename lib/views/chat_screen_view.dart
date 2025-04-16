import 'package:flutter/material.dart';

// TODO: Import models (Message)
// TODO: Import controller/provider

class ChatScreenView extends StatefulWidget {
  // Pass adventureId to know which adventure to load/display
  final String? adventureId; // Nullable if starting a new adventure?

  const ChatScreenView({super.key, required this.adventureId});

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // TODO: Get controller instance (e.g., via Provider)
  // late ChatScreenController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: Initialize controller and load initial chat data based on widget.adventureId
    // _controller = Provider.of<ChatScreenController>(context, listen: false);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _controller.loadChatScreen(widget.adventureId);
    // });
    print("ChatScreenView initState for adventure: ${widget.adventureId}");
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      final text = _textController.text.trim();
      // TODO: Call controller's handleSendMessage(text)
      print("Send button tapped: $text");
      _textController.clear();
      _scrollToBottom(); // Scroll after sending
    }
  }

  void _rollDice() {
    // TODO: Call controller's handleDiceRoll()
    print("Dice Roll button tapped");
    _scrollToBottom(); // Scroll after action
  }

  void _toggleAudio(bool enabled) {
     // TODO: Call controller's handleAudioToggle(enabled)
     print("Audio toggle tapped: $enabled");
  }

  // Helper to scroll to the bottom of the message list
  void _scrollToBottom() {
    // Add a small delay to allow the list to update before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Listen to controller state changes (e.g., using Consumer or Selector)
    // final controller = context.watch<ChatScreenController>(); // Example

    // Placeholder data
    final String scenarioTitle = "Scenario Title Placeholder";
    final List<dynamic> messages = [
      {'sender': 'AI', 'content': 'Welcome adventurer! What is your name?'},
      {'sender': 'User', 'content': 'My name is Roo.'},
      {'sender': 'AI', 'content': 'A fine name! Now, choose your path: Warrior, Mage, or Thief?'},
    ];
    bool isAudioEnabled = false; // Placeholder

    // TODO: Update message list based on controller.messages
    // TODO: Update scenarioTitle based on controller.currentAdventure?.scenarioTitle

    // Scroll to bottom when messages change (might need adjustment based on state management)
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Text(scenarioTitle),
        // Back button is implicitly added by Navigator
      ),
      body: Column(
        children: [
          // --- Message List ---
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['sender'] == 'User';
                return _buildMessageBubble(
                  context,
                  text: message['content'],
                  isUser: isUserMessage,
                );
              },
            ),
          ),
          // --- Input Area ---
          const Divider(height: 1.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            color: Theme.of(context).cardColor, // Use card color for background
            child: Row(
              children: [
                // Text Input Field
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Enter your message...',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(), // Send on keyboard submit
                  ),
                ),
                // Dice Roll Button
                IconButton(
                  icon: const Icon(Icons.casino_outlined), // Dice icon
                  tooltip: 'Roll D20',
                  onPressed: _rollDice,
                  color: Colors.blue.shade300,
                ),
                 // Audio Toggle Button
                IconButton(
                  icon: Icon(isAudioEnabled ? Icons.volume_up_outlined : Icons.volume_off_outlined),
                  tooltip: isAudioEnabled ? 'Disable Audio' : 'Enable Audio',
                  onPressed: () => _toggleAudio(!isAudioEnabled), // Toggle state
                  color: Colors.blue.shade300,
                ),
                // Send Button
                IconButton(
                  icon: const Icon(Icons.send),
                  tooltip: 'Send',
                  onPressed: _sendMessage,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Message Bubble
  Widget _buildMessageBubble(BuildContext context, {required String text, required bool isUser}) {
    final theme = Theme.of(context);
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser ? theme.primaryColor.withOpacity(0.8) : theme.cardTheme.color ?? Colors.grey.shade800;
    final textColor = isUser ? Colors.white : theme.textTheme.bodyMedium?.color ?? Colors.white;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(12.0),
      topRight: const Radius.circular(12.0),
      bottomLeft: isUser ? const Radius.circular(12.0) : Radius.zero,
      bottomRight: isUser ? Radius.zero : const Radius.circular(12.0),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: alignment,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}