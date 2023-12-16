import 'package:flutter/services.dart';

const MethodChannel channel = MethodChannel('template_workspace');

Future<String> getDeviceUniqueId() async{
  return await channel.invokeMethod('get_unique_id');
}