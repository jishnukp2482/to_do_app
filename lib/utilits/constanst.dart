import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:hive/hive.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:to_do_app/utilits/mystrings.dart';
import'package:to_do_app/database/hive_db.dart';

//Warning:empty titles & subtitle textfields

emptyfieldswarning(context) {
  return FToast.toast(
    context,
    msg: mystring.oopsmsg,
    subMsg: "You must fill all Fields",
    corner: 15,
    duration: 2000,
    padding: EdgeInsets.all(20),
  );
}

// Nothing Enter When user try to edit the current tesk

nothingenteronupdatetaskmode(context) {
  return FToast.toast(
    context,
    msg: mystring.oopsmsg,
    subMsg: "You must edit the tasks then try to update it!",
    corner: 15,
    duration: 3000,
    padding: EdgeInsets.all(20),
  );
}

//warning-no task

dynamic warningnotask(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: mystring.oopsmsg,
    message:
        "There is no Task For Delete!\n Try adding some and then try to delete it!",
    buttonText: "Ok",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

//Delete all task dialog

dynamic deletealltask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    message:
        "Do You really want to delete all tasks? You will no be able to undo this action!",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapConfirm: () {
    
    },
    onTapCancel: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
    title: mystring.areyousure,
    
  );
}
