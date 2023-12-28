import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class UniviewPlayerView extends StatefulWidget {
  final int winIndex;
  const UniviewPlayerView({super.key, required this.winIndex});

  @override
  State<UniviewPlayerView> createState() => _UniviewPlayerViewState();
}

class _UniviewPlayerViewState extends State<UniviewPlayerView> {
  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = '<live-player-view>';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'winIndex': widget.winIndex
    };

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
