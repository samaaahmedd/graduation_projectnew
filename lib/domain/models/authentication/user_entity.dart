import 'package:equatable/equatable.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';

class UserEntity extends Equatable {
  final String name;
  final String phoneNumber;
  final String age;
  final String emailAddress;
  final String password;
  final String gender;
  final String country;
  final String image;
  final List<String> languages;
  final String countryOfResidence;
  final String experience;

  UserEntity(
      {required this.name,
      required this.phoneNumber,
      required this.age,
      required this.emailAddress,
      required this.password,
      required this.gender,
      required this.country,
      this.languages = const [],
      this.countryOfResidence = '',
      this.experience = '',
      this.image = ''});

  Map<String, dynamic> toMap() {
    return {
      FireBaseUserKeys.name: name,
      FireBaseUserKeys.email: emailAddress,
      FireBaseUserKeys.password: password,
      FireBaseUserKeys.phone: phoneNumber,
      FireBaseUserKeys.gender: gender,
      FireBaseUserKeys.age: age,
      FireBaseUserKeys.country: country,
      FireBaseUserKeys.languages: languages,
      FireBaseUserKeys.countryOfResidence: countryOfResidence,
      FireBaseUserKeys.experience: experience,
    };
  }

  static UserEntity fromJson(Map<String, dynamic> json) {
    return UserEntity(
      age: json[FireBaseUserKeys.age].toString(),
      country: json[FireBaseUserKeys.country].toString(),
      emailAddress: json[FireBaseUserKeys.email].toString(),
      gender: json[FireBaseUserKeys.gender].toString(),
      name: json[FireBaseUserKeys.name].toString(),
      password: json[FireBaseUserKeys.password].toString(),
      phoneNumber: json[FireBaseUserKeys.phone].toString(),
      image: json[FireBaseUserKeys.image].toString(),
      countryOfResidence: json[FireBaseUserKeys.countryOfResidence].toString(),
      experience: json[FireBaseUserKeys.experience].toString(),
      languages: (json[FireBaseUserKeys.languages] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  @override
  String toString() {
    return 'UserEntity{name: $name, phoneNumber: $phoneNumber, age: $age, emailAddress: $emailAddress, password: $password, gender: $gender, country: $country, image: $image, languages: $languages, countryOfResidence: $countryOfResidence, experience: $experience}';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        age,
        country,
        countryOfResidence,
        languages,
        experience,
        phoneNumber,
        emailAddress,
        password,
        image,
        name,
        gender
      ];
}
