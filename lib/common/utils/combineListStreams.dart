
import 'dart:async';

Stream<List<T>> combineListStreams<T>(List<Stream<List<T>>> streams) {
  var controller = StreamController<List<T>>();
  Set activeStreams = {};
  Map<Stream<List<T>> , List<T>> lastValues = {};
  List<StreamSubscription> subscriptions = [];
  for (var stream in streams) {
    activeStreams.add(stream);
    var subscription = stream.listen(
            (val) {
          lastValues[stream] = val;
          List<T> out = [];
          for (var list in lastValues.values) {
            out.addAll(list);
          }
          controller.add(out);
        },
        onDone: () {
          activeStreams.remove(stream);
          if (activeStreams.isEmpty) {
            controller.close();
          }
        }
    );
    subscriptions.add(subscription);
  }
  controller.onCancel = () {
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
  };
  return controller.stream;
}
