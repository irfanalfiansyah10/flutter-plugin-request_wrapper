library mcnmr_request_wrapper;

import 'package:flutter/widgets.dart';

class RequestWrapper<T> extends ChangeNotifier{
  static const STATUS_LOADING = 0x222;
  static const STATUS_LOADING_KEEP_STATE = 0x224;
  static const STATUS_FINISHED = 0x223;

  int status = STATUS_LOADING;

  T get result => _result;
  T _result;

  ///
  /// if initialValue is not null
  /// it will change status to STATUS_FINISHED
  /// and emit the value to the result
  ///
  RequestWrapper({T initialValue}){
    if(initialValue != null){
      finishRequest(initialValue);
    }
  }

  ///
  /// if last status is not STATUS_LOADING
  /// it will change status to STATUS_LOADING
  ///
  void doRequest(){
    if(status != STATUS_LOADING) {
      status = STATUS_LOADING;
      notifyListeners();
    }
  }

  ///
  /// if last status is not STATUS_LOADING_KEEP_STATE
  /// it will change status to STATUS_LOADING_KEEP_STATE
  ///
  void doRequestKeepState(){
    if(status != STATUS_LOADING_KEEP_STATE) {
      status = STATUS_LOADING_KEEP_STATE;
      notifyListeners();
    }
  }

  ///
  /// if last status is not STATUS_FINISHED
  /// it will change status to STATUS_FINISHED
  ///
  void finishRequest(T newValue){
    if(status != STATUS_FINISHED) {
      status = STATUS_FINISHED;
      _result = newValue;
      notifyListeners();
    }
  }

  ///
  /// return true if status is not FINISHED 
  ///
  bool notFinishedYet(){
    return status != STATUS_FINISHED;
  }

  ///
  /// return true if status is not FINISHED or result is NULL
  ///
  bool notFinishedOrNullResult(){
    return status != STATUS_FINISHED || result == null;
  }

  ///
  /// if value not null will execute
  /// finishRequest()
  ///
  void finishRequestIfNotNull(T newValue){
    if(newValue != null) {
      finishRequest(newValue);
    }
  }

  void subscribe(Function(T value) subscriber){
    addListener((){
      subscriber(result);
    });
  }

  void subscribeOnNonNull(Function(T value) subscriber){
    addListener((){
      if(result != null) {
        subscriber(result);
      }
    });
  }

  void subscribeOnFinished(Function() subscriber){
    addListener((){
      if(status == STATUS_FINISHED){
        subscriber();
      }
    });
  }

  void subscribeOnFinishedAndNonNull(Function(T value) subscriber){
    addListener((){
      if(status == STATUS_FINISHED && result != null) {
        subscriber(result);
      }
    });
  }
}