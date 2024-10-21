import 'package:simple_apod/core/constants.dart';
import 'package:simple_apod/model/apod.dart';
import 'package:http/http.dart' as http;

class FetchApi {
  static Future<Apod> getData(String? date) async {
    var url = '$apiUrl?api_key=$apiKey';
    if (date != null) {
      url = '$url&date=$date';
    }

    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        return Apod.fromJson(res.body);
      }
      throw Exception('apod http exception');
    } catch (e) {
      rethrow;
    }
  }
}
