/// Represents the essential information of a scenario for display.
class Scenario {
  final String id; // Unique identifier (assigned during loading)
  final String title; // From JSON 'Name'
  final String genre; // Derived from JSON 'Tags' or default
  final String description; // From JSON 'Ambiance' or default

  Scenario({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
  });

  // Factory constructor to create a Scenario from the detailed JSON map
  factory Scenario.fromJson(Map<String, dynamic> json, String generatedId) {
    // Helper to safely get the first tag or a default value
    String _getGenre(dynamic tags) {
      if (tags is List && tags.isNotEmpty && tags[0] is String) {
        return tags[0];
      }
      return 'Gênero Desconhecido'; // Default genre
    }

    // Helper to safely get ambiance or a default value
    String _getDescription(dynamic ambiance) {
       if (ambiance is String && ambiance.isNotEmpty) {
         return ambiance;
       }
       return 'Sem descrição disponível.'; // Default description
    }

    return Scenario(
      id: generatedId, // Use the ID generated during loading
      title: json['Name'] as String? ?? 'Cenário sem Título',
      genre: _getGenre(json['Tags']),
      description: _getDescription(json['Ambiance']),
    );
  }

  // Method to convert a Scenario instance back to a simplified JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'description': description,
      // Note: This doesn't represent the original complex JSON structure
    };
  }
}