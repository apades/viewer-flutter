import 'package:http/http.dart' as http;

Future request(String url) async {
  String _url = url;
  // if (true) {
  //   _url = "http://192.168.199.144:3001/proxy?url=${Uri.encodeComponent(url)}";
  // }
  try {
    var res = await http.get(_url);
    return res.body;
  } catch (err) {
    return Future.error('requset err $err');
  }
}
