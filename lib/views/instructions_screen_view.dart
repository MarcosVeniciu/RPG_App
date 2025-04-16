import 'package:flutter/material.dart';

// TODO: Import controller/provider

class InstructionsScreenView extends StatelessWidget {
  const InstructionsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Connect to Controller/Provider to get instructions content
    // final controller = context.watch<InstructionsScreenController>();

    // Placeholder content
    final String instructionsContent = """
# Welcome to the RPG Adventure App! (Placeholder)

## Getting Started
*   Find ongoing adventures or start new ones on the Main Screen.
*   Continue adventures from where you left off.

## Gameplay
*   Interact via chat.
*   AI guides character creation.
*   Use the Dice Roll button when needed.

## Subscriptions
*   Manage tiers and buy extra adventures on the Subscription screen.

Have fun!
""";
    bool isLoading = false; // Placeholder

    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
        leading: IconButton( // Explicit back/close button
          icon: const Icon(Icons.close),
          tooltip: 'Close',
          onPressed: () {
            // TODO: Call controller's handleCloseAction or simply Navigator.pop(context)
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            print("Close button tapped");
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Make content scrollable
              padding: const EdgeInsets.all(16.0),
              child: Text(
                instructionsContent,
                // TODO: Apply specific text styling (sci-fi font, neon highlights if possible via theme or spans)
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
    );
  }
}