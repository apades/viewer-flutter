import 'package:http/http.dart' as http;

Future request(String url) async {
  String _url = url;
  if (true) {
    _url = Uri.encodeComponent(url);
  }
  try {
    var res = await http.get("http://192.168.199.144:3001/proxy?url=$_url");
    return res.body;
  } catch (err) {
    return Future.error('requset err $err');
  }
}
