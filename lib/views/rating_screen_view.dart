import 'package:flutter/material.dart';

// TODO: Import controller/provider

class RatingScreenView extends StatefulWidget {
  final String adventureId;
  final String adventureTitle; // To display in the header

  const RatingScreenView({
    super.key,
    required this.adventureId,
    required this.adventureTitle,
  });

  @override
  State<RatingScreenView> createState() => _RatingScreenViewState();
}

class _RatingScreenViewState extends State<RatingScreenView> {
  final TextEditingController _commentController = TextEditingController();

  // Local state to hold ratings before submitting
  int _overallRating = 0;
  int _storyEngagementRating = 0;
  int _aiHelpfulnessRating = 0;

  // TODO: Get controller instance
  // late RatingScreenController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: Initialize controller
    // _controller = Provider.of<RatingScreenController>(context, listen: false);
    // _controller.loadRatingScreen(widget.adventureId, widget.adventureTitle); // Pass initial data
    print("RatingScreenView initState for adventure: ${widget.adventureTitle} (${widget.adventureId})");
  }

   @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    // TODO: Call controller's handleSubmitFeedback, passing the ratings and comment
    print("Submit Feedback Tapped:");
    print("  Overall: $_overallRating");
    print("  Story: $_storyEngagementRating");
    print("  AI: $_aiHelpfulnessRating");
    print("  Comment: ${_commentController.text}");
    // TODO: Navigate back to MainScreen after submission (likely handled by controller)
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Connect to controller if needed (e.g., for loading state or error messages)
    // final controller = context.watch<RatingScreenController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate: ${widget.adventureTitle}'),
        automaticallyImplyLeading: false, // Prevent back button if navigation is handled on submit
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How was your adventure?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Overall Satisfaction Rating
            _buildRatingSection(
              context,
              label: 'Overall Satisfaction:',
              currentRating: _overallRating,
              onRatingUpdate: (rating) {
                setState(() => _overallRating = rating);
                // TODO: Notify controller if needed: _controller.handleStarSelection('overall', rating);
              },
            ),
            const SizedBox(height: 16),

            // Story Engagement Rating
            _buildRatingSection(
              context,
              label: 'How engaging was the story?',
              currentRating: _storyEngagementRating,
              onRatingUpdate: (rating) {
                setState(() => _storyEngagementRating = rating);
                 // TODO: Notify controller: _controller.handleStarSelection('story', rating);
              },
            ),
            const SizedBox(height: 16),

            // AI Helpfulness Rating
            _buildRatingSection(
              context,
              label: 'How helpful was the AI?',
              currentRating: _aiHelpfulnessRating,
              onRatingUpdate: (rating) {
                setState(() => _aiHelpfulnessRating = rating);
                 // TODO: Notify controller: _controller.handleStarSelection('ai', rating);
              },
            ),
            const SizedBox(height: 24),

            // Additional Comments
            Text(
              'Additional Comments (Optional):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.blue.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.blue.shade200, width: 2),
                ),
              ),
              // TODO: Notify controller on change if needed: onChanged: _controller.handleCommentInput,
            ),
            const SizedBox(height: 32),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for a Rating Section (Label + Stars)
  Widget _buildRatingSection(BuildContext context, {required String label, required int currentRating, required ValueChanged<int> onRatingUpdate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center stars
          children: List.generate(5, (index) {
            final ratingValue = index + 1;
            return IconButton(
              icon: Icon(
                ratingValue <= currentRating ? Icons.star : Icons.star_border,
                color: Colors.amber.shade400, // Neon-like yellow/gold
                size: 36,
              ),
              tooltip: '$ratingValue star${ratingValue > 1 ? 's' : ''}',
              onPressed: () => onRatingUpdate(ratingValue),
            );
          }),
        ),
      ],
    );
  }
}