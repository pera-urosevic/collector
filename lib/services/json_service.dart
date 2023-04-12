import 'dart:convert';

const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

String encode(dynamic o) {
  return _encoder.convert(o);
}

dynamic decode(String json) {
  return jsonDecode(json);
}
