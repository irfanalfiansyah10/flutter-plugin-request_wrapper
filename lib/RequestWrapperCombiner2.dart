import 'package:mcnmr_request_wrapper/RequestWrapper.dart';

class RequestWrapperCombiner2<A, B, C> extends RequestWrapper<C> {
  int loadingType = RequestWrapper.STATUS_LOADING;

  void asLoading() {
    loadingType = RequestWrapper.STATUS_LOADING;
  }

  void asLoadingKeepState() {
    loadingType = RequestWrapper.STATUS_LOADING_KEEP_STATE;
  }

  RequestWrapperCombiner2.combine(
      RequestWrapper<A> a, RequestWrapper<B> b, C Function(A, B) map,
      {C initialValue}) {
    if (initialValue != null) {
      finishRequest(initialValue);
    }

    void _notify(A a, B b) {
      finishRequest(map(a, b));
    }

    void _listen() {
      var condition = a.status == RequestWrapper.STATUS_FINISHED &&
          b.status == RequestWrapper.STATUS_FINISHED;

      if (!condition) {
        if (loadingType == RequestWrapper.STATUS_LOADING) {
          doRequest();
        } else {
          doRequestKeepState();
        }
        return;
      }

      _notify(a.result, b.result);
    }

    a.addListener(() {
      _listen();
    });

    b.addListener(() {
      _listen();
    });
  }
}
