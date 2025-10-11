import 'dart:convert';

import 'package:than_pkg/t_database/data_io.dart';
import 'package:than_pkg/t_database/t_database.dart';

abstract class JsonDatabase<T> extends TDatabase<T> {
  final DataIO io;
  JsonDatabase({required super.root}) : io = JsonIO.instance;

  T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap(T value);
  String getId(T value);
  List<T> _list = [];

  @override
  Future<List<T>> getAll({Map<String, dynamic>? query = const {}}) async {
    if (_list.isNotEmpty) return _list;
    final json = await io.read(root);
    if (json.isEmpty) return [];
    List<dynamic> jsonList = jsonDecode(json);
    _list = jsonList.map((e) => fromMap(e)).toList();
    return _list;
  }

  @override
  Future<void> add(T value) async {
    _list.add(value);
    notify(TDatabaseListenerTypes.add, null);
    await save(_list);
  }

  @override
  Future<void> delete(String id) async {
    final index = _list.indexWhere((e) => getId(e) == id);
    if (index == -1) {
      throw Exception('id: $id Not Found!');
    }
    _list.removeAt(index);
    await save(_list);
  }

  @override
  Future<void> update(String id, T value) async {
    final index = _list.indexWhere((e) => getId(e) == id);
    if (index == -1) {
      throw Exception('id: $id Not Found!');
    }
    _list[index] = value;
    await save(_list);
  }

  Future<void> save(List<T> list, {bool isPretty = true}) async {
    final jsonList = list.map((e) => toMap(e)).toList();
    if (isPretty) {
      await io.write(root, JsonEncoder.withIndent(' ').convert(jsonList));
    } else {
      await io.write(root, jsonEncode(jsonList));
    }
    notify(TDatabaseListenerTypes.saved, null);
  }
}
