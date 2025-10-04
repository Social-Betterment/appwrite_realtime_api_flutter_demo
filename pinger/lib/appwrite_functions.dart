import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';

class AppwriteFunctions {
  final Functions functions;
  final Storage storage;
  final Account account;

  AppwriteFunctions(Client client)
    : functions = Functions(client),
      storage = Storage(client),
      account = Account(client);

  Future<String> ponger() async {
    try {
      final execution = await functions.createExecution(
        functionId: '68e05c980002f0a686f6',
        body: jsonEncode({'ping': 'ping'}),
      );

      if (execution.status.toString() == 'failed') {
        debugPrint('Appwrite function execution failed: ${execution.errors}');
        return 'Appwrite function execution failed: ${execution.errors}';
      }

      final responseData = jsonDecode(execution.responseBody);

      if (responseData['ok'] != true) {
        debugPrint('Execute ponger failed: ${responseData['error']}');
        return 'Execute ponger failed: ${responseData['error']}';
      }
      return 'Ponger returned ${responseData['message']}';
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      return 'An unexpected error occurred: $e';
    }
  }
}
