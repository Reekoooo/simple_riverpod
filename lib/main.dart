import 'package:flutter/material.dart';
import 'package:simple_river_pod/riverpod/riverpod.dart';

void main() {
  runApp(const RiverPodSimple());
}

class RiverPodSimple extends StatelessWidget {
  const RiverPodSimple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scope(
      child: const MaterialApp(
        home: Scaffold(
          floatingActionButton: OtherButton(),
          body: CounterBody(),
        ),
      ),
    );
  }
}

class CounterBody extends StatelessWidget {
  const CounterBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer(
            builder: (watch) => Text(
              'You Pressed this ${(watch(counter) as Counter).count} times',
              style: const TextStyle(fontSize: 30.0),
            ),
          ),
          ElevatedButton(
            onPressed: (context.read(counter) as Counter).increment,
            child: const Text('Press'),
          ),
        ],
      ),
    );
  }
}

otherPage() {
  return MaterialPageRoute(
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
            title: Consumer(
              builder: (watch) =>
                  Text('My Second page ${(watch(alert) as Alert).value}'),
            )),
        body: const CounterBody(),
      );
    },
  );
}

class OtherButton extends StatelessWidget {
  const OtherButton({Key? key}) : super(key: key);

  final icon = const Icon(Icons.add_circle_outline_sharp);

  @override
  Widget build(BuildContext context) {
    _onPressed() {
      Navigator.of(context).push(otherPage());
    }

    return IconButton(
      icon: icon,
      onPressed: _onPressed,
    );
  }
}

//context.read(counter)

extension Read on BuildContext {
  read(Provider provider) {
    return dependOnInheritedWidgetOfExactType<Scope>()?.read(provider);
  }
}

final counter = Provider((read, watch) => Counter());

final alert = Provider((read, watch) {
  final count = (watch(counter) as Counter).count;
  return Alert(count);
});

class Counter extends ChangeNotifier {
  int count = 0;

  increment() {
    count++;
    notifyListeners();
  }
}

class Alert extends ChangeNotifier {
  int value;

  Alert(this.value) {
    Future.delayed(const Duration(seconds: 2), () => notifyListeners());
  }
}
