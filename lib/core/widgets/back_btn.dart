import 'package:flutter/material.dart';

import '../../config/router/navigation_helper.dart';

Widget backBtn() => IconButton(
  onPressed: () => NavigationHelper.pop(),
  icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey),
      ),
    ),
    fixedSize: WidgetStateProperty.all(const Size(40, 40)),
  ),
);
