import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

class RealtimeNotifier extends ChangeNotifier {
  final Client _client;
  Realtime? _realtime;
  RealtimeSubscription? _subscription;
  final StreamController<RealtimeMessage> _streamController =
      StreamController.broadcast();

  RealtimeNotifier(this._client);

  void initialize() {
    if (_subscription != null) return;

    _realtime = Realtime(_client);
    _subscription = _realtime!.subscribe(['documents']);
    _subscription!.stream.listen((message) {
      _streamController.add(message);
      debugPrint('Realtime message received: $message');
    });
    notifyListeners();
  }

  Stream<RealtimeMessage> get stream => _streamController.stream;

  void close() {
    _subscription?.close();
    _subscription = null;
  }

  @override
  void dispose() {
    close();
    _streamController.close();
    super.dispose();
  }
}
