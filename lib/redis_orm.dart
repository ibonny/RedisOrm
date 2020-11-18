import 'dart:convert';
import 'dart:mirrors';
import 'package:crypto/crypto.dart';

import 'package:dartis/dartis.dart';

const Id = 'Id';

class RedisOrm<T> {
  var connectString;
  var client;

  RedisOrm(this.connectString);

  Future<bool> connect() async {
    client = await Client.connect(connectString);

    return true;
  }

  Future<bool> putValue(String key, String value) async {
    final commands = client.asCommands<String, String>();

    await commands.set('key', 'value');

    return true;
  }

  Future<String> getValue(String key) async {
    final commands = client.asCommands<String, String>();

    final result = await commands.get('key');

    return result;
  }

  String getMD5(String str) {
    return md5.convert(utf8.encode(str)).toString();
  }

  Future<String> put(dynamic rec) async {
    final commands = client.asCommands<String, String>();

    final jsonStr = jsonEncode(rec);

    final key = getMD5(jsonStr);

    await commands.set(key, jsonStr);

    return key;
  }

  Future<T> get(String key) async {
    final commands = client.asCommands<String, String>();

    String jsonStr = await commands.get(key);

    Map map = jsonDecode(jsonStr);

    T t = Activator.createInstance(T);

    var result = reflect(T).invoke(Symbol('fromJson'), [map]);

    return result.reflectee;
  }

  void close() async {
    await client.disconnect();
  }
}

class Activator {
  static createInstance(Type type, [Symbol constructor, List arguments, Map<Symbol, dynamic> namedArguments]) {
    if (type == null) {
      throw ArgumentError('type: $type');
    }

    constructor ??= const Symbol('');

    arguments ??= const [];

    var typeMirror = reflectType(type);
    if (typeMirror is ClassMirror) {
      return typeMirror.newInstance(constructor, arguments, namedArguments).reflectee;
    } else {
      throw ArgumentError("Cannot create the instance of the type '$type'.");
    }
  }
}