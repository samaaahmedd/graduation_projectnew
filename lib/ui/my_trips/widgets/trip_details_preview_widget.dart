import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';

import 'trip_header_widget.dart';
import 'trip_icon_tile_widget.dart';

class TripDetailsPreviewWidget extends StatelessWidget {
  final TripEntity trip;
  const TripDetailsPreviewWidget({Key? key, required this.trip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(trip.description,
              style: TextStyles.regular(
                  fontSize: 16, color: AppColors.neutral_600, height: 1.3)),
        ),
        // const AppDivider(height: 1.5),
        const TripHeaderRowWidget(
          text: "Activities",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(trip.activities,
              maxLines: 3,
              style: TextStyles.medium(
                  fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
        ),
        const TripHeaderRowWidget(
          text: "Trip Details",
        ),
        TripIconTileWidget(
            icon: Icons.access_time_rounded, text: '${trip.duration}  Day'),
        TripIconTileWidget(icon: Iconsax.location, text: trip.meetingPoint),
        TripIconTileWidget(
            icon: Icons.person, text: '${trip.noPersons}  Person'),
        TripIconTileWidget(
            icon: Icons.monetization_on_outlined, text: trip.price),
        TripIconTileWidget(icon: Iconsax.mobile, text: trip.phoneNumber),
        const TripHeaderRowWidget(
          text: "Not Allowed",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(trip.notAllowed,
              maxLines: 3,
              style: TextStyles.medium(
                  fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
        ),
        const TripHeaderRowWidget(
          text: "Notes",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(trip.notes,
              maxLines: 3,
              style: TextStyles.medium(
                  fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
        ),
        const SizedBox(
          height: 70,
        ),
      ],
    );
  }
}
