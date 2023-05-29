import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';

class UserEntity {
  final String name;
  final String phoneNumber;
  final String age;
  final String emailAddress;
  final String password;
  final String gender;
  final String country;

  UserEntity({
    required this.name,
    required this.phoneNumber,
    required this.age,
    required this.emailAddress,
    required this.password,
    required this.gender,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      FireBaseUserKeys.name: name,
      FireBaseUserKeys.email: emailAddress,
      FireBaseUserKeys.password: password,
      FireBaseUserKeys.phone: phoneNumber,
      FireBaseUserKeys.gender: gender,
      FireBaseUserKeys.age: age,
      FireBaseUserKeys.country: country,
    };
  }

  static UserEntity fromJson(Map<String, dynamic> json) {
    print('------------------------------------');
    print(json.toString());
    return UserEntity(
      age: json[FireBaseUserKeys.age].toString(),
      country: json[FireBaseUserKeys.country].toString(),
      emailAddress: json[FireBaseUserKeys.email].toString(),
      gender: json[FireBaseUserKeys.gender].toString(),
      name: json[FireBaseUserKeys.name].toString(),
      password: json[FireBaseUserKeys.password].toString(),
      phoneNumber: json[FireBaseUserKeys.phone].toString(),
    );
  }
}
