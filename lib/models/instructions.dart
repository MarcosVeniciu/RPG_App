/// Represents the data related to the instructions screen.
class Instructions {
  final String content; // Contains the instructions text
  final bool isFirstLaunch; // Flag to detect if it is the first launch

  Instructions({
    required this.content,
    required this.isFirstLaunch,
  });

  // Note: This model might primarily be used for displaying data fetched
  // by InstructionsService and might not need JSON serialization itself,
  // unless the content or flag is stored/fetched as JSON.
}