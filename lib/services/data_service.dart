String titleCase(String str) {
  if (str.toLowerCase() == 'uid') return 'UID';
  if (str.toLowerCase() == 'id') return 'ID';
  String tc = str.split(' ').map((s) => s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase()).join(' ');
  return tc;
}

String formatDatetime(String datetime) {
  DateTime? dt = DateTime.tryParse(datetime);
  if (dt == null) return '';
  return dt.toIso8601String().substring(0, 19).replaceFirst('T', ' ');
}

String formatDate(String date) {
  DateTime? dt = DateTime.tryParse(date);
  if (dt == null) return '';
  return dt.toIso8601String().substring(0, 10).replaceFirst('T', ' ');
}
