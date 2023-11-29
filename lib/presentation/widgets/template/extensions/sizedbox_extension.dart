import 'package:flutter/material.dart' show SizedBox;

extension Size on num{
  SizedBox get h => SizedBox(height: toDouble(),);
  SizedBox get w => SizedBox(width: toDouble(),);
}
