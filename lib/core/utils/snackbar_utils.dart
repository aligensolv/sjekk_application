import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_snackbar.dart';

enum SnackBarType { success, failure, info }

class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message, {SnackBarType type = SnackBarType.info}) {
    if(type == SnackBarType.success){
      ScaffoldMessenger.of(context).showSnackBar(TemplateSuccessSnackbar(message));
    }else if(type == SnackBarType.failure){
      ScaffoldMessenger.of(context).showSnackBar(TemplateErrorSnackbar(message));
    }else if(type == SnackBarType.info){
      ScaffoldMessenger.of(context).showSnackBar(TemplateInfoSnackbar(message));
    }
  }
}
