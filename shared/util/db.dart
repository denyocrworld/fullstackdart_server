import 'package:mysql1/mysql1.dart';

class DB {
  static MySqlConnection? _connection;

  static Future<MySqlConnection> _getConnection() async {
    if (_connection == null) {
      final settings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'admin',
        password: 'admin',
        db: 'fullstackdart_db',
      );

      _connection = await MySqlConnection.connect(settings);
    }

    return _connection!;
  }

  static Future<List<Map<String, dynamic>>> select(String table,
      {List<String>? columns, String? where, List<dynamic>? whereArgs}) async {
    final conn = await _getConnection();
    final query = StringBuffer('SELECT ');

    if (columns != null) {
      query.writeAll(columns, ',');
    } else {
      query.write('*');
    }

    query.write(' FROM $table');

    if (where != null) {
      query.write(' WHERE $where');
    }

    final results = await conn.query(query.toString(), whereArgs);
    final resultList = <Map<String, dynamic>>[];

    for (final row in results) {
      final rowMap = <String, dynamic>{};
      for (final key in row.fields.keys) {
        rowMap[key] = row[key];
      }
      resultList.add(rowMap);
    }

    return resultList;
  }

  static Future<int> insert(String table, Map<String, dynamic> values) async {
    final conn = await _getConnection();
    final query = StringBuffer('INSERT INTO $table (');
    final keys = values.keys.toList();
    final List<String> placeholders = List.generate(keys.length, (_) => '?');

    query.writeAll(keys, ',');
    query.write(') VALUES (');
    query.writeAll(placeholders, ',');
    query.write(')');

    final result = await conn.query(query.toString(), values.values.toList());
    return result.insertId!;
  }

  static Future<int> update(String table, Map<String, dynamic> values,
      {String? where, List<dynamic>? whereArgs}) async {
    final conn = await _getConnection();
    final query = StringBuffer('UPDATE $table SET ');

    final keys = values.keys.toList();
    final List<String> placeholders = List.generate(keys.length, (index) {
      return '${keys[index]} = ?';
    });

    query.writeAll(placeholders, ',');

    if (where != null) {
      query.write(' WHERE $where');
    }

    final result = await conn.query(
        query.toString(), [...values.values.toList(), ...whereArgs ?? []]);

    return result.affectedRows!;
  }

  static Future<int> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final conn = await _getConnection();
    final query = StringBuffer('DELETE FROM $table');

    if (where != null) {
      query.write(' WHERE $where');
    }

    final result = await conn.query(query.toString(), whereArgs);

    return result.affectedRows!;
  }
}
