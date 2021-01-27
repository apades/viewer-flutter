import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viewer/utils/request.dart';
import 'package:viewer/views/Gallery.dart';

import 'package:flutter_js/flutter_js.dart';
// void main() {
//   runApp(Myapp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.green,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/gallery': (ctx) => PageGallery()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _Item {
  final int n;
  final Color color;

  const _Item({this.color, this.n});
}

class _MyHomePageState extends State<MyHomePage> {
  List<_Item> _items = <_Item>[];

  JavascriptRuntime jsctx;

  @override
  initState() {
    super.initState();
    jsctx = getJavascriptRuntime();

    jsctx.onMessage('log', (dynamic args) {
      print("msg $args");
    });
  }

  Widget gridBuilder() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
      ),
      // itemCount: 15,
      itemBuilder: (context, index) {
        if (_items.length <= index) {
          print('new $index');
          var a = 20;
          while (a-- > 0) {
            int radomNum = Random.secure().nextInt(10) * 100;
            _items.add(new _Item(n: radomNum, color: Colors.teal[radomNum]));
          }
        }

        _Item item = _items[index];
        return Container(
          padding: const EdgeInsets.all(8),
          child: Text('this is $index item ${item.n}'),
          color: item.color,
        );
      },
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.live_tv),
              onPressed: () {
                Navigator.pushNamed(ctx, '/gallery');
              })
        ],
      ),
      body: Center(
        child: gridBuilder(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // jsctx.evaluate("var window = global = globalThis;");
          // String fetchJs = await rootBundle.loadString("js/fetch.js");
          // await jsctx.evaluateAsync(fetchJs + "");
          JsEvalResult rs = jsctx.evaluate("""
          XMLHttpRequest
""");
          // jsctx.enableHandlePromises();
          // JsEvalResult rs2 = await jsctx.handlePromise(rs);
          print("rs ${rs}");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
