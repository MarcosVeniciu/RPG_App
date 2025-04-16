import 'dart:convert'; // For jsonDecode
import 'dart:io'; // For File and Directory operations
import 'package:flutter/foundation.dart'; // For kDebugMode or error logging
// import 'package:path_provider/path_provider.dart'; // Use if relative path fails

import '../models/scenario.dart';
import 'backend_service.dart';

/// Simulated implementation of [BackendService] that reads scenario data
/// from local JSON files stored in the 'scenarios/' directory relative
/// to the project root (during development) or potentially application assets.
///
/// **Note:** Accessing relative paths like './scenarios/' directly might only work
/// reliably during development/testing from the IDE. For a production build,
/// scenarios should likely be bundled as assets and read using rootBundle.
/// This implementation prioritizes simplicity for the simulation as requested.
class SimulatedBackendService implements BackendService {
  final String _scenariosDirPath = 'scenarios'; // Relative path

  @override
  Future<List<Scenario>> fetchScenarios() async {
    final List<Scenario> scenarios = [];
    try {
      final dir = Directory(_scenariosDirPath);
      if (!await dir.exists()) {
        if (kDebugMode) {
          print("Error: Scenarios directory '$_scenariosDirPath' not found.");
        }
        // Consider throwing a specific exception or returning empty list
        return [];
      }

      final List<FileSystemEntity> entities = await dir.list().toList();
      final List<File> jsonFiles = entities
          .whereType<File>() // Filter out directories/links
          .where((file) => file.path.toLowerCase().endsWith('.json'))
          .toList();

      if (jsonFiles.isEmpty) {
         if (kDebugMode) {
          print("No .json files found in '$_scenariosDirPath'.");
        }
      }

      for (final file in jsonFiles) {
        try {
          // Extract filename without extension to use as ID
          final String filenameWithExt = file.path.split(Platform.pathSeparator).last;
          final String scenarioId = filenameWithExt.endsWith('.json')
              ? filenameWithExt.substring(0, filenameWithExt.length - 5) // Remove .json
              : filenameWithExt; // Fallback if no extension

          final String content = await file.readAsString();
          final Map<String, dynamic> jsonMap = jsonDecode(content);
          // Pass the extracted ID to the factory constructor
          scenarios.add(Scenario.fromJson(jsonMap, scenarioId));
        } catch (e) {
          // Log error for specific file and continue with others
          if (kDebugMode) {
            print("Error reading or parsing scenario file ${file.path}: $e");
          }
        }
      }
    } catch (e) {
      // Log general error during directory access or listing
      if (kDebugMode) {
        print("Error accessing scenarios directory '$_scenariosDirPath': $e");
      }
      // Rethrow or return empty list based on desired error handling
      // throw Exception('Failed to fetch scenarios: $e');
    }
    return scenarios;
  }
}