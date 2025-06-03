import 'package:flutter/material.dart';

Future<T> showLoader<T>(BuildContext context,Future<T> future) async{
  final overlayState=Overlay.of(context)!;
  final entry=OverlayEntry(builder: (_)=>Container(
    color: Colors.black,
    child: Container(
      color: Color(0xFF2B6178),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white,backgroundColor: Colors.grey,),
      ),
    ),
  )
  );
  overlayState.insert(entry);
  final result=await future;
  entry.remove();
  return result;
}