import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/extenstions.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:with_you_app/ui/home/taps/trip_tap_widget.dart';
import 'package:with_you_app/ui/home/taps/trip_user_info_tap.dart';

class TripDetailsBody extends StatefulWidget {
  final TripEntity tripEntity;
  final UserEntity user;
  const TripDetailsBody({Key? key, required this.tripEntity, required this.user})
      : super(key: key);

  @override
  State<TripDetailsBody> createState() => _TripDetailsBodyState();
}

class _TripDetailsBodyState extends State<TripDetailsBody> {
  _TapEnum selectedTap = _TapEnum.tripDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TabBarWidget(
          tapEnum: selectedTap,
          onTap: (value) {
            selectedTap = value;
            setState(() {});
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IndexedStack(
              index: selectedTap.index,
              children: [
                TripTapWidget(tripEntity: widget.tripEntity),
                TripUserInfoTap(user: widget.user),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabBarWidget extends StatelessWidget {
  _TabBarWidget({Key? key, required this.tapEnum, required this.onTap})
      : super(key: key);

  final List<String> tapsLabel = ['Details', 'Guide Info'];

  final _TapEnum tapEnum;
  final void Function(_TapEnum) onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColors.forthColor),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: tapsLabel
            .mapIndexed((e, i) => Expanded(
          child: InkWell(
            onTap: () {
              onTap(_TapEnum.values[i]);
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: tapEnum == _TapEnum.values[i]
                      ? AppColors.neutral_500
                      : AppColors.forthColor),
              child: Text(e,
                  style: TextStyles.bold(
                      color: tapEnum == _TapEnum.values[i]
                          ? Colors.white
                          : AppColors.neutral_600)),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}

enum _TapEnum { tripDetails, guideInfo }
