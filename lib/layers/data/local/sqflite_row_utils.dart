/// Helpers for sqflite [QueryResultSet]: it implements [List] and may be **empty**
/// (e.g. `SELECT … FROM settings` with no rows). Never use `[0]` / `.first` unchecked.
Object? firstSqfliteRowValue(List<Map<String, Object?>> rows, String column) {
  if (rows.isEmpty) return null;
  return rows.first[column];
}

/// `SELECT MAX(id) as latestId FROM …` — null / missing / empty-safe.
int? parseLatestIdFromMaxQuery(List<Map<String, Object?>> rows) {
  final Object? raw = firstSqfliteRowValue(rows, 'latestId');
  if (raw == null) return null;
  final String s = raw.toString().trim();
  if (s.isEmpty || s == 'null') return null;
  return int.tryParse(s);
}
