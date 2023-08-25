import 'dart:async';

import 'package:http/http.dart' as http;

class CounterService {
  Stream<int> get counterStream => _counterStreamController.stream;
  StreamController<int> _counterStreamController = StreamController<int>();

  int _counter = 0;

  CounterService() {
    _fetchCounter();
  }

  Future<void> _fetchCounter() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/counter/value'));
    if (response.statusCode == 200) {
      _counter = int.parse(response.body);
      _counterStreamController.add(_counter);
    }
  }

  void incrementCounter() async {
    try {
      final response = await http
          .post(Uri.parse('http://localhost:8080/counter/value/increment'));
      if (response.statusCode == 200) {
        _fetchCounter();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void dispose() {
    _counterStreamController.close();
  }
}
