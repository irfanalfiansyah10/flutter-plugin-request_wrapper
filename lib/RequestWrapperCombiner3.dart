import 'package:mcnmr_request_wrapper/RequestWrapper.dart';

class RequestWrapperCombiner3<A, B, C, D> extends RequestWrapper<D> {
  int loadingType = RequestWrapper.STATUS_LOADING;

  void asLoading() {
    loadingType = RequestWrapper.STATUS_LOADING;
  }

  void asLoadingKeepState() {
    loadingType = RequestWrapper.STATUS_LOADING_KEEP_STATE;
  }

  RequestWrapperCombiner3.combine(RequestWrapper<A> a, RequestWrapper<B> b,
      RequestWrapper<C> c, D Function(A, B, C) map,
      {D initialValue}) {
    if (initialValue != null) {
      finishRequest(initialValue);
    }

    void _notify(A a, B b, C c) {
      finishRequest(map(a, b, c));
    }

    void _listen() {
      var condition = a.status == RequestWrapper.STATUS_FINISHED &&
          b.status == RequestWrapper.STATUS_FINISHED &&
          c.status == RequestWrapper.STATUS_FINISHED;

      if (!condition) {
        if (loadingType == RequestWrapper.STATUS_LOADING) {
          doRequest();
        } else {
          doRequestKeepState();
        }
        return;
      }

      _notify(a.result, b.result, c.result);
    }

    a.addListener(() => _listen());
    b.addListener(() => _listen());
    c.addListener(() => _listen());
  }
}
