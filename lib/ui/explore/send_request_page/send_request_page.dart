// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_date_picker.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/models/requests/requests.dart';
import 'package:with_you_app/domain/use_cases/user/reguest_user_use_case.dart';
import 'package:with_you_app/ui/explore/explore_user_card.dart';

import '../../../common/material/app_text_form_field.dart';

class SendRequestPage extends StatefulWidget {
  const SendRequestPage({Key? key, required this.userEntity}) : super(key: key);
  final UserEntity userEntity;

  @override
  State<SendRequestPage> createState() => _SendRequestPageState();
}

class _SendRequestPageState extends State<SendRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentUser = FirebaseAuth.instance.currentUser;
  DateTime? birthDate;
  final RequestUserUseCase _requestUserUseCase = RequestUserUseCase();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _numberPersonsController =
      TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.defaultAppBar(context, title: 'Send Request'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserCard(
                user: widget.userEntity,
                onTap: () {},
                padding: 0,
              ),
              const SizedBox(
                height: 20,
              ),
              AppCustomDateField(
                label: 'Date',
                hintText: 'Request in Date!',
                onchange: (dateTime) {
                  _dateController.text=dateTime.toString();
                  birthDate = dateTime; setState(() {

                  });
                },
                textEditingController: _dateController,
              ),
              AppTextFormField(
                controller: _numberPersonsController,
                label: "Number Of Persons",
                hint: "Number Of Persons in trip",
                maxLength: 3,
                keyboardType: TextInputType.number,
              ),
              AppTextFormField(
                controller: _durationController,
                label: "Booking Duration",
                hint: "Booking Duration need in days ",
                maxLength: 3,
                keyboardType: TextInputType.number,
              ),
              widget.userEntity.type != 'Tourist'
                  ? const SizedBox()
                  : AppTextFormField(
                      controller: _priceController,
                      label: "Expected Price",
                      hint: "Expected Price ( per hour )",
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return null;
                      },
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(25),
        height: 48,
        child: AppButtons.primaryButton(
          text: 'Send Request',
          isLoading: _isLoading,
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              _isLoading = true;
              setState(() {});
              RequestEntity requestEntity = RequestEntity(
                  userId: _currentUser?.email ?? '',
                  requestedUserId: widget.userEntity.emailAddress,
                  date: _dateController.text,
                  numberOfPersons: _numberPersonsController.text,
                  bookingDuration: _durationController.text,
                  expectedPrice: _priceController.text,
                  requestState: FireBaseRequestUserKeys.waitingState);
              final result =
                  await _requestUserUseCase.execute(context, requestEntity);
              if (result) {
                pop(context);
                pop(context);
              }
              _isLoading = false;
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}
