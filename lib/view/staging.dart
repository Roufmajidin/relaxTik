import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view_model/tiket-controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String url;
  final String title;

  const WebViewExample({super.key, required this.url, required this.title});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  @override
  Widget build(BuildContext context) {
    final conti = Provider.of<TiketController>(context, listen: false);
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(
            const PlatformWebViewControllerCreationParams());
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              conti.reloadHalaman();
            },
          )),
      body: WebViewWidget(controller: controller),
    );
  }
}
