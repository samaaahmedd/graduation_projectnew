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
  final String city;
  final String experience;
  final String pricePerHour;
  final String rate;
  final String type;

  const UserEntity({
    required this.name,
    required this.phoneNumber,
    required this.age,
    required this.emailAddress,
    required this.password,
    required this.gender,
    required this.country,
    this.languages = const [],
    this.countryOfResidence = '',
    this.experience = '',
    this.image = '',
    this.city = '',
    this.pricePerHour = '',
    this.rate = '0',
    this.type = '',
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
      FireBaseUserKeys.languages: languages,
      FireBaseUserKeys.countryOfResidence: countryOfResidence,
      FireBaseUserKeys.experience: experience,
      FireBaseUserKeys.city: city,
      FireBaseUserKeys.rate: rate,
      FireBaseUserKeys.pricePerHour: pricePerHour,
      FireBaseUserKeys.type: type,
    };
  }

  static UserEntity fromJson(Map<String, dynamic> json) {
    final List<String> languages = (json[FireBaseUserKeys.languages] as List?)
            ?.map((e) => e as String)
            .toList() ??
        <String>[];
    return UserEntity(
      age: json[FireBaseUserKeys.age].toString(),
      country: json[FireBaseUserKeys.country].toString(),
      emailAddress: json[FireBaseUserKeys.email].toString(),
      gender: json[FireBaseUserKeys.gender].toString(),
      name: json[FireBaseUserKeys.name].toString(),
      password: json[FireBaseUserKeys.password].toString(),
      phoneNumber: json[FireBaseUserKeys.phone].toString(),
      image: json[FireBaseUserKeys.image].toString(),
      pricePerHour: json[FireBaseUserKeys.pricePerHour].toString(),
      city: json[FireBaseUserKeys.city].toString(),
      rate: json[FireBaseUserKeys.rate].toString(),
      countryOfResidence: json[FireBaseUserKeys.countryOfResidence].toString(),
      experience: json[FireBaseUserKeys.experience].toString(),
      type: json[FireBaseUserKeys.type].toString(),
      languages: languages,
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
