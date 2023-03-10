import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // detect Android back button click
        final controller = webViewController;
        if (controller != null) {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          }
        }
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("InAppWebView test"),
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: InAppWebView(
                key: webViewKey,
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        javaScriptCanOpenWindowsAutomatically: true)),
                initialUrlRequest: URLRequest(
                    url: Uri.parse("https://techsindia.com/test/page1.html")),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onConsoleMessage: (controller, consoleMessage) {
                  /*
                  Since onCloseWindow does not detect window.close event 
                  this is was the only workaround                  
                  */

                  if (consoleMessage.message ==
                      'Scripts may close only the windows that were opened by them.') {
                    controller.loadUrl(
                        urlRequest: URLRequest(
                            url: Uri.parse(
                                'https://techsindia.com/test/page1.html')));
                  }
                },
              ),
            ),
          ])),
    );
  }
}
