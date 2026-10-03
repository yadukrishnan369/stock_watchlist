import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 700)});

  // Run action after user stops typing
  void run(void Function() action) {
    _timer?.cancel();

    _timer = Timer(delay, action);
  }

  // Cancel pending search
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  // Clean timer
  void dispose() {
    _timer?.cancel();
  }
}
