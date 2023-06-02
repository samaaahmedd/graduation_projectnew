// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/common/material/app_text_form_field.dart';
import 'package:with_you_app/common/material/divider.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:with_you_app/domain/use_cases/trips/create_trip_use_case.dart';
import 'widgets/pick_image_widget.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({Key? key}) : super(key: key);

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final CreateTripUseCase _createTripUseCase = CreateTripUseCase();
  final _formKey = GlobalKey<FormState>();
  bool _createLoading = false;
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _activitiesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _meetingPointController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _allowedNumberPersonsController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _notAllowedController = TextEditingController();
  List<File> images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.leadingAppBar(
        context,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Create Your Trip', style: TextStyles.bold(fontSize: 26)),
              const AppDivider(),
              const SizedBox(height: 20),
              PickImageWidget(
                label: 'Trip Popular Places Images :',
                onchange: (pickedList) {
                  images = pickedList;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              AppTextFormField(
                label: "Trip Title",
                hint: "Your trip title",
                maxLines: 2,
                minLines: 1,
                controller: _tripNameController,
              ),
              AppTextFormField(
                label: "Price",
                hint: "Your trip price for all persons",
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              AppTextFormField(
                label: "Activities",
                hint:
                    "Type your trip Activities and most popular places to visit...",
                maxLines: 10,
                minLines: 7,
                controller: _activitiesController,
              ),
              AppTextFormField(
                label: "Description",
                hint: "Your trip Description ...",
                maxLines: 7,
                minLines: 5,
                controller: _descriptionController,
              ),
              AppTextFormField(
                label: "Meeting Point",
                hint: "Meeting location in details ...",
                maxLines: 5,
                minLines: 3,
                controller: _meetingPointController,
              ),
              AppTextFormField(
                label: "Allowed No.Person",
                hint: "Type number of allowed persons in trip",
                controller: _allowedNumberPersonsController,
                keyboardType: TextInputType.number,
                maxLength: 2,
              ),
              AppTextFormField(
                label: "Trip Duration",
                hint: "Type your trip duration in days",
                controller: _durationController,
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
              AppTextFormField(
                label: "Contact Phone Number",
                hint: "Phone number can contact with you",
                controller: _phoneController,
                keyboardType: TextInputType.number,
                maxLength: 11,
              ),
              AppTextFormField(
                label: "Notes",
                hint:
                    "Notes to persons like : no meals with the trip provided or we will use public transport",
                maxLines: 8,
                minLines: 5,
                controller: _notesController,
              ),
              AppTextFormField(
                label: "Not Allowed",
                hint:
                    "Notes to persons to know before you go\nLike: smoking not allowed , bets not allowed,children not allowed",
                maxLines: 8,
                minLines: 5,
                controller: _notAllowedController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: AppButtons.primaryButton(
                    isLoading: _createLoading,
                    text: 'Create Trip',
                    onPressed: _createTripFun),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createTripFun() async {
    if (_formKey.currentState?.validate() == true && images.isNotEmpty) {
      setState(() {
        _createLoading = true;
      });
      TripEntity tripEntity = TripEntity(
          title: _tripNameController.text,
          price: _priceController.text,
          activities: _activitiesController.text,
          description: _descriptionController.text,
          meetingPoint: _meetingPointController.text,
          noPersons: _allowedNumberPersonsController.text,
          duration: _durationController.text,
          phoneNumber: _phoneController.text,
          notes: _notesController.text,
          notAllowed: _notAllowedController.text,
          images: [],
          pickedImages: images);
      final result = await _createTripUseCase.execute(context, tripEntity);
      if (result) {
        pop(context);
      }
      setState(() {
        _createLoading = false;
      });
    } else {
      if (images.isEmpty) {
        AppSnackBars.hint(context,
            title: 'Images cant be empty,please select trip image first');
      }
    }
  }
}
