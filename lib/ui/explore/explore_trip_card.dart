import 'package:flutter/material.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';

class ExploreTripCard extends StatelessWidget {
  const ExploreTripCard(
      {Key? key,
      required this.onTap,
      required this.tripDetails,
      this.animationController,
      this.animation})
      : super(key: key);
  final VoidCallback onTap;
  final TripEntity tripDetails;

  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 320,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 8),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: AppColors.neutral_30),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.neutral_30,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(1, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppNetworkImage(
                        path: tripDetails.images.first,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tripDetails.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.bold(
                                  fontSize: 18, color: AppColors.neutral_100)),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(tripDetails.description,
                              style: TextStyles.regular(
                                  fontSize: 16, color: AppColors.neutral_600)),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: _tile(
                                      icon: Icons.access_time_rounded,
                                      text: '${tripDetails.duration} Day')),
                              _tile(
                                  icon: Icons.monetization_on_outlined,
                                  text: tripDetails.price),
                              const SizedBox(
                                width: 25,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tile({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.neutral_400),
          const SizedBox(
            width: 7,
          ),
          Text(text,
              style: TextStyles.regular(
                  fontSize: 15, color: AppColors.neutral_400)),
        ],
      ),
    );
  }
}