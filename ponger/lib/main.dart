import 'dart:async';
import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

// This Appwrite function will be executed every time your function is triggered
Future<dynamic> main(final context) async {
  // You can use the Appwrite SDK to interact with other services
  // For this example, we're using the Users service
  final client = Client()
      .setEndpoint(Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'] ?? '')
      .setProject(Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ?? '')
      .setKey(context.req.headers['x-appwrite-key'] ?? '');

  final databaseId =
      Platform.environment['APPWRITE_FUNCTION_DATABASE_ID'] ?? '';
  final tableId = 'ping';

  try {
    TablesDB tables = TablesDB(client);
    final rows = await tables.listRows(
      databaseId: databaseId,
      tableId: tableId,
    );
    context.log(
      'Sucessfully fetched ${rows.total} rows from the Appwrite database service',
    );
    final now = DateTime.now().toIso8601String();
    await tables.updateRow(
      databaseId: databaseId,
      tableId: tableId,
      rowId: rows.rows[0].$id,
      data: {'pingedAt': now},
    );
    context.log(
      'Sucessfully updated row ${rows.rows[0].$id} in the Appwrite database service',
    );

    return context.res.json({'ok': true, 'message': now}, 200);
  } catch (e) {
    context.error('Test Ponger Function Error: $e');
    return context.res.json({'ok': false, 'error': e.toString()}, 200);
  }
}
