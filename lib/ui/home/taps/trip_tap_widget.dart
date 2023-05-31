import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/divider.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:with_you_app/ui/my_trips/widgets/trip_details_preview_widget.dart';

class TripTapWidget extends StatefulWidget {
  final TripEntity tripEntity;
  const TripTapWidget({Key? key, required this.tripEntity}) : super(key: key);

  @override
  State<TripTapWidget> createState() => _TripTapWidgetState();
}

class _TripTapWidgetState extends State<TripTapWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GridView.builder(
            itemCount: widget.tripEntity.images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .65,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage.assetNetwork(
                  image: widget.tripEntity.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: ' ',
                  placeholderErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.withOpacity(.3),
                    );
                  },
                ),
              );
            },
          ),
          const AppDivider(verticalPadding: 20, horizontalPadding: 7),
          TripDetailsPreviewWidget(
            trip: widget.tripEntity,
          ),
          const SizedBox(height: 100,),
        ],
      ),
    );
  }
}
