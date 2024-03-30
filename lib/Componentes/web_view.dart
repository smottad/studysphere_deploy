import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HTMLScreen extends StatefulWidget {
  const HTMLScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HTMLScreenState();
}

class _HTMLScreenState extends State<HTMLScreen> {
  late final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    final path = ModalRoute.of(context)?.settings.arguments as String;
    _controller = WebViewController()..loadFlutterAsset(path);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        title: Text((path.endsWith('y.html')
            ? "Políticas de privacidad"
            : "Términos y condiciones")),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
