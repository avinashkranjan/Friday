import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showErrToast(String errorMsg, FToast errToast) {
  if (errorMsg == null) return;
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.transparent,
    ),
    child: Text(
      errorMsg,
      style: TextStyle(color: Colors.red),
    ),
  );

  errToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}
