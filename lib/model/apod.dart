import 'dart:convert';

class Apod {
  String? mediaType;
  String? title;
  String? url;

  Apod({this.mediaType, this.title, this.url});

  Apod.fromJson(dynamic rawJson) {
    final json = jsonDecode(rawJson);
    mediaType = json['media_type'];
    title = json['title'];
    url = json['url'];
  }
}
