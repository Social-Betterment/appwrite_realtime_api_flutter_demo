import 'dart:async';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:pinger/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:pinger/appwrite_functions.dart';
import 'package:pinger/login_view.dart';
import 'realtime_notifier.dart';
import 'environment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String endpoint = Environment.appwritePublicEndpoint;
  static const String projectId = Environment.appwriteProjectId;

  @override
  Widget build(BuildContext context) {
    final Client client = Client().setEndpoint(endpoint).setProject(projectId);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState(client)),
        ChangeNotifierProvider<RealtimeNotifier>(
          create: (_) => RealtimeNotifier(client),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Consumer<AuthState>(
          builder: (context, authState, child) {
            if (authState.user == null) {
              return const LoginView();
            }
            return const MyHomePage(title: 'Flutter Demo Home Page');
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _response = 'Response will be shown here';
  String _realtimeEvent = 'No events yet';
  StreamSubscription? _realtimeSubscription;

  void _incrementCounter() async {
    _subscribeToRealtime();
    final client = context.read<AuthState>().client;
    final AppwriteFunctions appwriteFunctions = AppwriteFunctions(client);
    _response = await appwriteFunctions.ponger();
    debugPrint('Response from ponger: $_response');
    setState(() {
      _counter++;
    });
  }

  void _subscribeToRealtime() {
    if (_realtimeSubscription != null) return;
    final realtimeNotifier = context.read<RealtimeNotifier>();
    realtimeNotifier.initialize();
    _realtimeSubscription = realtimeNotifier.stream.listen((event) {
      debugPrint('Real-time event from provider: $event');
      if (event.channels.any((c) => c.contains('ping'))) {
        setState(() {
          _realtimeEvent = event.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    if (_realtimeSubscription != null) {
      _realtimeSubscription?.cancel();
      _realtimeSubscription = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('API Response: $_response'),
            Text('Realtime Response: $_realtimeEvent'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Ping',
        child: const Icon(Icons.add),
      ),
    );
  }
}
