import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oktoast/oktoast.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '快哉小课',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '快哉小课'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  WebViewController _webViewController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
        preferredSize:Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child:SafeArea(
          top: true,
          child: Offstage(),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'http://192.168.1.114/dyy_my_product?source=Android',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController){
            _controller.complete(webViewController);
            _webViewController = webViewController;
          },
          onPageFinished: (String url){
           print('加载完成');
          },
          javascriptChannels: <JavascriptChannel>[
             _toasterJavascriptChannel(context),
          ].toSet(),
        );

      }),
//      floatingActionButton: jsButton(),
      floatingActionButton: FloatingActionButton(
           child: const Icon(Icons.add),
          onPressed: (){
             _webViewController.evaluateJavascript('callJS()');
          }
      ),
    );

  }
  Widget jsButton(){
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder: (BuildContext context,
          AsyncSnapshot<WebViewController> controller){
        if(controller.hasData){
          return FloatingActionButton(
            onPressed: () async{
              _controller.future.then((controller){
                controller.evaluateJavascript('callJS()');
//                    .then((result){});
              });

            },
            child: Text('Flutter Call JS'),
          );
        }
        return Container();
      },
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
      return JavascriptChannel(
          name:'Toaster',
          onMessageReceived: (JavascriptMessage message){
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(message.message))
            );
//            showToast(message.message);
        }
      );

  }
}
