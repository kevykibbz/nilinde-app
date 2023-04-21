import 'package:Nilinde/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:Nilinde/exceptions/exceptions.dart';

class CreateSnackBar{

  //error snackbar
  static buildErrorSnackbar(BuildContext context,SignUpWithEmailAndPasswordFailure ex) {
    return QuickAlert.show(
      context:context,
      type:QuickAlertType.error,
      text:ex.message,
      confirmBtnColor:Theme.of(context).colorScheme.secondary,
    );
  }

  //succcess
  static buildSuccessSnackbar({required BuildContext context,required String message,required VoidCallback onPress}) {
    return QuickAlert.show(
      context:context,
      type:QuickAlertType.success,
      text:message,
      confirmBtnColor:Theme.of(context).colorScheme.secondary,
      onConfirmBtnTap:onPress
    );
  }

  //error
  static buildCustomErrorSnackbar(context,String title,String message) {
    return QuickAlert.show(
      context:context,
      type:QuickAlertType.error,
      text:message,
      confirmBtnColor:Theme.of(context).colorScheme.secondary
    );
  }
}