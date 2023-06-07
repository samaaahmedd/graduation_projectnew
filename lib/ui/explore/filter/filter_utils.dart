import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'filter_model.dart';

class FilterUtils {
  List<UserEntity> users = [];
  List<UserEntity> filteredList = [];
  FilterModel filterModel = FilterModel.initial();
  void filter() {
    filteredList = [];
    _filterUserType();
    _filterGender();
    _filterCountry();
    _filterLanguages();
    sort();
  }

  void _filterUserType() {
    if (filterModel.userType == userFilterTypeList[0]) {
      filteredList.addAll(users);
    } else {
      for (var item in users) {
        if (filterModel.userType == item.type) {
          filteredList.add(item);
        }
      }
    }
  }

  void _filterGender() {
    List<UserEntity> genderFiltered = [];
    if (filterModel.gender == filterGenderList[0]) {
      genderFiltered = filteredList;
    } else {
      for (UserEntity item in filteredList) {
        if (filterModel.gender == item.gender) {
          genderFiltered.add(item);
        }
      }
    }
    filteredList = genderFiltered;
  }

  void _filterCountry() {
    List<UserEntity> countryList = [];
    if (filterModel.country == null) {
      countryList = filteredList;
    } else {
      for (UserEntity item in filteredList) {
        if (filterModel.country == item.countryOfResidence) {
          countryList.add(item);
        }
      }
    }
    filteredList = countryList;
  }

  void _filterLanguages() {
    List<UserEntity> languagesFilteredList = [];
    if (filterModel.languages.isEmpty) {
      languagesFilteredList = filteredList;
    } else {
      for (UserEntity item in filteredList) {
        bool containsValue = item.languages
            .any((element) => filterModel.languages.contains(element));
        if (containsValue) {
          languagesFilteredList.add(item);
        }
      }
    }
    filteredList = languagesFilteredList;
  }

  void sort() {
    if (filterModel.sortValue == sortList[0]) {
      filteredList.sort((a, b) => b.rate.compareTo(a.rate));
    } else if (filterModel.sortValue == sortList[1]) {
      filteredList.sort((a, b) => a.rate.compareTo(b.rate));
    } else if (filterModel.sortValue == sortList[2]) {
      filteredList.sort((a, b) => b.pricePerHour.compareTo(a.pricePerHour));
    } else {
      filteredList
          .sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour ?? ''));
    }
  }
}
