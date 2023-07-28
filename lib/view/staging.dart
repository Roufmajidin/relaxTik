import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view_model/tiket-controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String url;

  WebViewExample({required this.url});

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
      appBar: AppBar(
          title: Text('Web View Example'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              conti.reloadHalaman();
            },
          )),
      body: WebViewWidget(controller: controller),
    );
  }
}
