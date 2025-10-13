import 'dart:convert';

import 'package:than_pkg/services/t_map.dart';
import 'package:than_pkg/t_database/data_io.dart';
import 'package:than_pkg/t_database/t_database.dart';

abstract class JsonDatabase<T> extends TDatabase<T> {
  final DataIO io;
  JsonDatabase({required super.root}) : io = JsonIO.instance;

  T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap(T value);
  String getId(T value);
  final List<T> _list = [];

  @override
  Future<List<T>> getAll({Map<String, dynamic>? query}) async {
    query ??= {};
    final isUsedCache = query.getBool(['isUsedCache']);
    if (isUsedCache && _list.isNotEmpty) return _list;

    final json = await io.read(root);
    if (json.isEmpty) return [];
    List<dynamic> jsonList = jsonDecode(json);
    _list.clear();
    final res = jsonList.map((e) => fromMap(e)).toList();
    _list.addAll(res);
    return _list;
  }

  @override
  Future<void> add(T value) async {
    _list.insert(0, value);
    notify(TDatabaseListenerTypes.add, getId(value));
    await save(_list, id: getId(value));
  }

  @override
  Future<void> delete(String id) async {
    final index = _list.indexWhere((e) => getId(e) == id);
    if (index == -1) {
      return;
      // throw Exception('id: $id Not Found!');
    }
    _list.removeAt(index);
    notify(TDatabaseListenerTypes.delete, id);
    await save(_list, id: id);
  }

  @override
  Future<void> update(String id, T value) async {
    final index = _list.indexWhere((e) => getId(e) == id);
    if (index == -1) {
      throw Exception('id: $id Not Found!');
    }
    _list[index] = value;
    notify(TDatabaseListenerTypes.update, id);
    await save(_list, id: id);
  }

  Future<void> save(List<T> list, {bool isPretty = true, String? id}) async {
    final jsonList = list.map((e) => toMap(e)).toList();
    if (isPretty) {
      await io.write(root, JsonEncoder.withIndent(' ').convert(jsonList));
    } else {
      await io.write(root, jsonEncode(jsonList));
    }
    notify(TDatabaseListenerTypes.saved, id);
  }
}
