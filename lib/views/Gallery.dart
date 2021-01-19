import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:viewer/utils/request.dart';

class PageGallery extends StatefulWidget {
  PageGallery({Key key}) : super(key: key);

  @override
  _PageGalleryState createState() => _PageGalleryState();
}

class _Item {
  final dynamic data;

  const _Item({this.data});
}

class _PageGalleryState extends State<PageGallery> {
  List<_Item> _items = <_Item>[];
  int _pid = 0;
  int _count = 0;

  bool _isOver = false;
  bool _isLoading = false;

  bool _isPageLoading = true;
  bool _isPageError = false;

  ScrollController _controller;

  loadData() async {
    if (_isOver || _isLoading) return;
    setState(() {
      _isLoading = true;
    });
    var dataList;
    try {
      dataList = jsonDecode(await request(
          "https://rule34.xxx/index.php?page=dapi&s=post&tags=dacad&q=index&json=1&limit=20&pid=$_pid"));
    } catch (err) {
      setState(() {
        _isPageError = true;
      });
    }
    // load over
    if (dataList.length == 0) {
      setState(() {
        _isOver = true;
      });
      return;
    }

    setState(() {
      if (_isPageLoading) _isPageLoading = false;
      _isLoading = false;
      _count += dataList.length;
      _pid += 1;
    });
    for (int i = 0; i < dataList.length; i++) {
      _items.add(new _Item(data: dataList[i]));
    }
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print('loadData $_pid $_count');
      // print('1 ${_controller.offset} ${_controller.position.maxScrollExtent}');
      loadData();
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print('2');
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    super.initState();
    loadData();
  }

  Widget gridBuilder() {
    return GridView.builder(
      controller: _controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
      ),
      itemCount: _count,
      itemBuilder: (context, index) {
        _Item item = _items[index];
        if (_items == null) return null;
        return Stack(
          // width: 10,
          // height: 10,
          // padding: const EdgeInsets.all(8),
          // child: Text(item.data['preview_url']),
          // child: ,
          children: [
            Image.network(
              item.data['preview_url'],
              width: 10,
              height: 10,
              // loadingBuilder: (),
            )
          ],
          alignment: AlignmentDirectional.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Stack(
        children: [
          Builder(builder: (BuildContext ctx) {
            print(ctx);
            if (_isPageLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return gridBuilder();
          }),
          Visibility(
            child: Positioned(
              child: CircularProgressIndicator(),
              left: 10,
              bottom: 10,
            ),
            visible: _isLoading,
          ),
        ],
      ),
    );
  }
}
