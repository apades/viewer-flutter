import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:viewer/config.dart';
import 'package:viewer/type/dataType.dart';
import 'package:viewer/utils/request.dart';
import 'package:viewer/views/Viewer.dart';

class PageGallery extends StatefulWidget {
  PageGallery({Key key}) : super(key: key);

  @override
  _PageGalleryState createState() => _PageGalleryState();
}

class _PageGalleryState extends State<PageGallery> {
  List<DataItem> _items = <DataItem>[];
  int _pid = 0;
  int _count = 0;

  bool _isOver = false;
  bool _isLoading = false;

  bool _isPageLoading = true;
  bool _isPageError = false;

  ScrollController _controller;

  AppConfig appConfig = AppConfig.getConfig();
  double _picWidth = 10;

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
      _items.add(new DataItem(data: dataList[i]));
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
    _picWidth = appConfig.mode == DevMode.sf ? 10 : null;
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
        DataItem item = _items[index];
        if (item == null) return null;
        return InkWell(
          onTap: () {
            print('img item ${item.data['id']}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => new PageViewer(
                  index: index,
                  items: _items,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Image.network(
                item.data['preview_url'],
                width: _picWidth,
                height: _picWidth,
                // loadingBuilder: (),
              ),
              Positioned(
                child: IconButton(
                  splashRadius: 1,
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    print('icon item ${item.data['id']}');
                  },
                ),
                right: 2,
                bottom: 2,
              ),
            ],
            alignment: AlignmentDirectional.center,
          ),
        );
        // return ;
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
            if (_isPageLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (_isPageError) {
              return Center(
                child: Text('page has some error'),
              );
            }
            return gridBuilder();
          }),
          Visibility(
            child: Positioned(
              child: CircularProgressIndicator(),
              left: 10,
              bottom: 10,
            ),
            visible: _isLoading && !_isPageLoading,
          ),
        ],
      ),
    );
  }
}
