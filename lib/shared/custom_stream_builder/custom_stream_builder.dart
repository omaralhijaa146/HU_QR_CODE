import 'package:flutter/cupertino.dart';

typedef StreamListener<T> = void Function(T value);

class CustomStreamBuilder extends StreamBuilder {
  final StreamListener listener;

  const CustomStreamBuilder({
    Key? key,
    initialData,
    Stream? stream,
    required this.listener,
    required AsyncWidgetBuilder builder,
  }) : super(
            key: key,
            initialData: initialData,
            stream: stream,
            builder: builder);

  @override
  AsyncSnapshot afterData(AsyncSnapshot current, data) {
    listener(data);
    return super.afterData(current, data);
  }
}
