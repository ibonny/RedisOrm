import 'package:redis_orm/redis_orm.dart';


class RedisModel {
  String firstName;
  String lastName;

  RedisModel();

  // RedisModel(this.firstName, this.lastName);

  String getFirstName() {
    return firstName;
  }

  void setFirstName(String fn) {
    firstName = fn;
  }

  String getLastName() {
    return lastName;
  }

  void setLastName(String ln) {
    firstName = ln;
  }

  // RedisModel.fromJson(Map<String, dynamic> json)
  //     : firstName = json['firstName'],
  //       lastName = json['lastName'];

  RedisModel fromJson(Map<String, dynamic> json) {
    var rm = RedisModel();

    rm.setFirstName(json['firstName']);
    rm.setLastName(json['lastName']);

    return rm;
  }

  Map<String, dynamic> toJson() =>
      {
        'firstName': firstName,
        'lastName': lastName,
      };
}

void main() async {
  final t = RedisOrm<RedisModel>('redis://192.168.1.169:6379');

  await t.connect();

  final m = RedisModel();

  m.setFirstName('Ian');
  m.setLastName('Bonnycastle');

  // print(await t.getValue('key'));

  final key = await t.put(m);

  print('Key is: $key');

  print(await t.get(key));

  t.close();
}