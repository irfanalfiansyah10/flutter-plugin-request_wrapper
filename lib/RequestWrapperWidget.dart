library mcnmr_request_wrapper;

import 'package:flutter/widgets.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';

typedef RequestWrapperBuilder<T> = Widget Function(BuildContext context, T data);

class RequestWrapperWidget<T> extends StatefulWidget {

  final RequestWrapper<T> requestWrapper;
  final Widget placeholder;
  final RequestWrapperBuilder<T> builder;

  RequestWrapperWidget({
    @required this.requestWrapper,
    @required this.placeholder,
    @required this.builder});

  @override
  State<RequestWrapperWidget<T>> createState() => _RequestWrapperWidgetState<T>();
}

class _RequestWrapperWidgetState<T> extends State<RequestWrapperWidget<T>> {

  bool isFinished = false;

  @override
  void initState() {
    super.initState();

    /**
     * Check if the wrapper has initial value
     */
    setState(() {
      isFinished = widget.requestWrapper.status == RequestWrapper.STATUS_FINISHED;
    });

    /**
     * Listen on status change in wrapper
     */
    widget.requestWrapper.addListener((){
      setState(() {
        isFinished = widget.requestWrapper.status == RequestWrapper.STATUS_FINISHED;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Build view, if wrapper status == STATUS_LOADING it will build based on placeholder widget
     * else if status == STATUS_LOADING_KEEP_STATE it will check whether the value null or not
     * if null it will build based on placeholder widget if not it will build based on builder widget
     * with last value
     * else if status == STATUS_FINISHED it will build based on builder widget with new value data
     */

    if (isFinished) {
      return widget.builder(context, widget.requestWrapper.result);
    } else {
      if (widget.requestWrapper.status == RequestWrapper.STATUS_LOADING_KEEP_STATE) {
        if (widget.requestWrapper.result == null) {
          return widget.placeholder;
        } else {
          return widget.builder(context, widget.requestWrapper.result);
        }
      } else {
        return widget.placeholder;
      }
    }
  }
}
