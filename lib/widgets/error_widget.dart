import 'package:flutter/material.dart';

class MyCustomErrorWidget extends StatelessWidget {
  final Object errObj;
  MyCustomErrorWidget(this.errObj);
  @override
  Widget build(BuildContext context) {
    print(errObj);
    return Container(
      alignment: Alignment.center,
      child: Text("Error : $errObj"),
    );
  }
}
