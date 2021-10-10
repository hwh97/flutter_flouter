import 'dart:async';

/// route uri
class FlouterUri<T> {
  final Completer<T?> _popCompleter = Completer<T?>();
  final Uri uri;

  Future<dynamic> get popped => _popCompleter.future;

  void complete(T? result, Duration completeWaitDuration) {
    if (!_popCompleter.isCompleted) {
      Future.delayed(completeWaitDuration).then((_){
        _popCompleter.complete(result);
      });
    }
  }

  FlouterUri(this.uri);

  @override
  String toString() {
    return uri.toString();
  }
}
