import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "main.g.dart";

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    final isPending = useState<Future<void>?>(null);
    final snapshot = useFuture(isPending.value);

    _handleOnTap() async {
      final future = ref.read(counterProvider.notifier).add();
      isPending.value = future;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Testing Riverpod"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            if (snapshot.connectionState == ConnectionState.waiting) ...[
              const CircularProgressIndicator(),
            ] else ...[
              Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleOnTap,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

@riverpod
class Counter extends _$Counter {
  @override
  FutureOr<int> build() async {
    return 0;
  }

  Future<void> add() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 2));
      final newValue = state.value! + 1;
      return newValue;
    });
  }
}
