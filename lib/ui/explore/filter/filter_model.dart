import 'package:equatable/equatable.dart';

class FilterModel extends Equatable {
  final String sortValue;
  final String userType;
  final String gender;
  final String? country;
  final List<String> languages;

  const FilterModel(
      {required this.sortValue,
      required this.userType,
      required this.gender,
      required this.country,
      required this.languages});

  FilterModel.initial()
      : this(
            userType: userFilterTypeList[0],
            sortValue: sortList[0],
            gender: filterGenderList[0],
            country: null,
            languages: []);

  FilterModel modify(
      {String? sortValue,
      String? userType,
      String? gender,
      String? country,
      List<String>? languages}) {
    return FilterModel(
      languages: languages ?? this.languages,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      sortValue: sortValue ?? this.sortValue,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [sortValue, userType, gender, country, languages];

  @override
  String toString() {
    return 'FilterModel{sortValue: $sortValue, userType: $userType, gender: $gender, country: $country, languages: $languages}';
  }
}

List<String> sortList = const [
  "Highest Rate",
  "Lowest Rate",
  "Highest Price",
  "Lowest Price"
];

List<String> userFilterTypeList = const [
  "All Users",
  "Tourist",
  "Tour Guide",
  "Photographer"
];

List<String> filterGenderList = const ["Both", "Male", "Female"];
