import 'package:mcnmr_request_wrapper/RequestWrapper.dart';

class RequestWrapperCombiner8<A, B, C, D, E, F, G, H, I>
    extends RequestWrapper<I> {
  int loadingType = RequestWrapper.STATUS_LOADING;

  void asLoading() {
    loadingType = RequestWrapper.STATUS_LOADING;
  }

  void asLoadingKeepState() {
    loadingType = RequestWrapper.STATUS_LOADING_KEEP_STATE;
  }

  RequestWrapperCombiner8.combine(
      RequestWrapper<A> a,
      RequestWrapper<B> b,
      RequestWrapper<C> c,
      RequestWrapper<D> d,
      RequestWrapper<E> e,
      RequestWrapper<F> f,
      RequestWrapper<G> g,
      RequestWrapper<H> h,
      I Function(A, B, C, D, E, F, G, H) map,
      {I initialValue}) {
    if (initialValue != null) {
      finishRequest(initialValue);
    }

    void _notify(A a, B b, C c, D d, E e, F f, G g, H h) {
      finishRequest(map(a, b, c, d, e, f, g, h));
    }

    void _listen() {
      var condition = a.status == RequestWrapper.STATUS_FINISHED &&
          b.status == RequestWrapper.STATUS_FINISHED &&
          c.status == RequestWrapper.STATUS_FINISHED &&
          d.status == RequestWrapper.STATUS_FINISHED &&
          e.status == RequestWrapper.STATUS_FINISHED &&
          f.status == RequestWrapper.STATUS_FINISHED &&
          g.status == RequestWrapper.STATUS_FINISHED &&
          h.status == RequestWrapper.STATUS_FINISHED;

      if (!condition) {
        if (loadingType == RequestWrapper.STATUS_LOADING) {
          doRequest();
        } else {
          doRequestKeepState();
        }
        return;
      }

      _notify(a.result, b.result, c.result, d.result, e.result, f.result,
          g.result, h.result);
    }

    a.addListener(() => _listen());
    b.addListener(() => _listen());
    c.addListener(() => _listen());
    d.addListener(() => _listen());
    e.addListener(() => _listen());
    f.addListener(() => _listen());
    g.addListener(() => _listen());
    h.addListener(() => _listen());
  }
}
