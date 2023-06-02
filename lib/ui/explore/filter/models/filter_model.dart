import 'country.dart';
import 'gender.dart';
import 'languages.dart';
import 'user_type.dart';

// make filter model using singleton pattern
// to save values in memory while application running

class FilterModel {
  static FilterModel? _instance;

  static FilterModel? getInstance() {
    _instance ??= FilterModel();
    return _instance;
  }

  UserType? _userType;
  double? _sliderValue;
  Gender? _gender;
  Languages? _language;
  Country? _country;

  void updateValues(UserType? userType, double? sliderValue, Gender? gender,
      Languages? language, Country? country) {
    _userType = userType;
    _sliderValue = sliderValue;
    _gender = gender;
    _language = language;
    _country = country;
  }

  void setDefaultValues() {
    _userType = UserType.All;
    _sliderValue = null;
    _gender = Gender.Both;
    _language = Languages.All;
    _country = Country.All;
  }

  void emptyAllValues() {
    _userType = null;
    _sliderValue = null;
    _gender = null;
    _language = null;
    _country = null;
  }

  UserType? get userType => _userType;

  double? get sliderValue => _sliderValue;

  Gender? get gender => _gender;

  Languages? get language => _language;

  Country? get country => _country;

  @override
  String toString() {
    return 'FilterModel{_userType: $_userType, _sliderValue: $_sliderValue, _gender: $_gender, _language: $_language, _country: $_country}';
  }
}
