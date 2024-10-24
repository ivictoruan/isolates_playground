import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

class MainApp2 extends StatefulWidget {
  const MainApp2({super.key});

  @override
  State<MainApp2> createState() => _MainApp2State();
}

Stream<String> getMessages() {
  final rp = ReceivePort();

  return Isolate.spawn(_getMessages, rp.sendPort)
      .asStream()
      .asyncExpand((_) => rp)
      .takeWhile((element) => element is String)
      .cast();
}

void _getMessages(SendPort sp) async {
  final Stream<String> results = Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now().toIso8601String(),
  ).take(10);

  await for (final String now in results) {
    log(now);
    sp.send(now);
  }
  Isolate.exit(sp);
}

class _MainApp2State extends State<MainApp2> {
  List<String> messages = [];

  bool loading = false;

  getViewMessages() async {
    loading = true;
    setState(() {});
    await for (final now in getMessages()) {
      messages.add(now);
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: messages.isEmpty
                      ? const Text('Sem mensagems!')
                      : ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text('Data da mensagem ${index + 1}'),
                            subtitle: Text(
                              messages[index],
                            ),
                          ),
                        ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: loading ? null : () async => await getViewMessages(),
            label: const Text('Get Persons'),
          ),
        ),
      ),
    );
  }
}
