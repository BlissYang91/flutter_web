import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget{
  String url;
  final String title;

   WebViewPage({this.url, this.title});

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage> {
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          new WebView(
            initialUrl: widget.url,
            onWebViewCreated: (WebViewController web){
              web.canGoBack().then((res){
                print(res);//是否能返回上一级
              });
              web.currentUrl().then((url){
                print(url); //当前url
              });
              web.canGoForward().then((res){
                print(res);//是否能前进
              });
            },
            onPageFinished: (String value){
              setState(() {
                _isLoading = false;
              });
            },
          ),
          _loading()

        ],
      ),
    );
  }
  _loading(){
    return _isLoading == true ? Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ): Text('');
  }

}