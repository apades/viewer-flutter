import 'package:flutter/material.dart';
import 'package:viewer/type/dataType.dart';
import 'package:viewer/utils/utils.dart';

class PageViewer extends StatefulWidget {
  final int index;
  final List<DataItem> items;
  PageViewer({Key key, this.index, this.items}) : super(key: key);

  @override
  _PageViewerState createState() => _PageViewerState();
}

class _PageViewerState extends State<PageViewer> {
  double nx = 0, ny = 0, ix = 0, iy = 0;
  DataItem item;
  int _index;

  @override
  initState() {
    super.initState();
    setState(() {
      item = widget.items[widget.index];
      _index = widget.index;
    });
  }
// this.initstat

  _incrementDown(PointerEvent details) {
    // print('down $ix,$iy,$nx,$ny');
    _updateLocation(details);
    setState(() {
      ix = details.position.dx;
      iy = details.position.dy;
    });
  }

  _updateLocation(PointerEvent details) {
    // print('move $ix,$iy,$nx,$ny');
    setState(() {
      nx = details.position.dx;
      ny = details.position.dy;
    });
  }

  _incrementUp(PointerEvent details) {
    _updateLocation(details);
    // print('up ix$ix, iy$iy, nx$nx, ny$ny');
    double offsetX = ix - nx, offsetY = iy - ny;
    print('up offsetX$offsetX, offsetY$offsetY');
    if (offsetX.abs() > 150 && offsetY.abs() < 90) {
      if (offsetX > 0) {
        setState(() {
          _index = minMax<int>(_index + 1, 0, widget.items.length);
          item = widget.items[_index];
        });
        print('next');
      } else {
        setState(() {
          _index = minMax<int>(_index - 1, 0, widget.items.length);
          item = widget.items[_index];
        });
        print('pre');
      }
    }
  }

  @override
  Widget build(BuildContext ctx) {
    // DataItem item = widget.items[widget.index];
    double width = MediaQuery.of(context).size.width;

    // print(item.data);
    return Scaffold(
        appBar: AppBar(
          title: Text(item.data['id'].toString()),
        ),
        body: Listener(
          onPointerMove: _updateLocation,
          onPointerDown: _incrementDown,
          onPointerUp: _incrementUp,
          child: Container(
            width: width,
            color: Colors.grey,
            child: Column(
              children: [
                Image.network(
                  item.data['file_url'],
                  width: 10,
                  height: 10,
                  loadingBuilder: (BuildContext ctx, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 300,
                      width: width,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
