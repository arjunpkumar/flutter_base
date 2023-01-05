import 'package:flutter/material.dart';
import 'package:thinkhub/src/core/constants.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        elevation: Units.kButtonElevation,
        child: Padding(
          padding: EdgeInsets.all(Units.kContentOffSet),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
