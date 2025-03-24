import 'package:flutter/widgets.dart';

abstract class StateNotifier<State> extends ChangeNotifier{

  StateNotifier(this._state):_oldState=_state;
  State _state,_oldState;

  State get state=>_state;
  State get oldState=>_oldState;

  set state(State newState){
    _update(newState);
  }

  void onlyUpdate(State newState){
    _update(newState,notify: false);
  }
  void _update(
      State newState,{
        bool notify=true
      }){
    if(_state!=newState){
      _oldState=_state;
      _state=newState;
      if(notify){
        notifyListeners();
      }
    }

  }

}