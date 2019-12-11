library mcnmr_request_wrapper;

import 'package:mcnmr_request_wrapper/RequestWrapper.dart';

class RequestWrapperCombiner5<A, B, C, D, E, F> extends RequestWrapper<F>{

  int loadingType = RequestWrapper.STATUS_LOADING;

  void asLoading(){
    loadingType = RequestWrapper.STATUS_LOADING;
  }

  void asLoadingKeepState(){
    loadingType = RequestWrapper.STATUS_LOADING_KEEP_STATE;
  }

  RequestWrapperCombiner5.combine(RequestWrapper<A> a,
      RequestWrapper<B> b,
      RequestWrapper<C> c,
      RequestWrapper<D> d,
      RequestWrapper<E> e,
      F Function(A, B, C, D, E) map,
      {F initialValue}){

    if(initialValue != null) {
      finishRequest(initialValue);
    }

    void _notify(A a, B b, C c, D d, E e){
      finishRequest(map(a, b, c, d, e));
    }

    void _listen(){
      var condition = a.status == RequestWrapper.STATUS_FINISHED &&
          b.status == RequestWrapper.STATUS_FINISHED &&
          c.status == RequestWrapper.STATUS_FINISHED &&
          d.status == RequestWrapper.STATUS_FINISHED &&
          e.status == RequestWrapper.STATUS_FINISHED;

      if(!condition){
        if(loadingType == RequestWrapper.STATUS_LOADING){
          doRequest();
        }else {
          doRequestKeepState();
        }
        return;
      }

      _notify(a.result, b.result, c.result, d.result, e.result);
    }

    a.addListener(() => _listen());
    b.addListener(() => _listen());
    c.addListener(() => _listen());
    d.addListener(() => _listen());
    e.addListener(() => _listen());
  }
}