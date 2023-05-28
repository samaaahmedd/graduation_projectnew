import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TripDetailsPage extends StatefulWidget {
  final TripEntity trip;
  const TripDetailsPage({Key? key, required this.trip}) : super(key: key);

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _SliderImagesWidget(imagesPaths: widget.trip.images),
                _rowTile(text: widget.trip.title, margin: 0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(widget.trip.description,
                      style: TextStyles.regular(
                          fontSize: 16,
                          color: AppColors.neutral_600,
                          height: 1.3)),
                ),
                // const AppDivider(height: 1.5),
                _rowTile(
                  text: "Activities",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(widget.trip.activities,
                      maxLines: 3,
                      style: TextStyles.medium(
                          fontSize: 15,
                          color: AppColors.neutral_600,
                          height: 1.3)),
                ),
                _rowTile(
                  text: "Trip Details",
                ),
                _iconTile(
                    Icons.access_time_rounded, '${widget.trip.duration}  Day'),
                _iconTile(Iconsax.location, widget.trip.meetingPoint),
                _iconTile(Icons.person, '${widget.trip.noPersons}  Person'),
                _iconTile(Icons.monetization_on_outlined, widget.trip.price),
                _iconTile(Iconsax.mobile, widget.trip.phoneNumber),
                _rowTile(
                  text: "Not Allowed",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(widget.trip.notAllowed,
                      maxLines: 3,
                      style: TextStyles.medium(
                          fontSize: 15,
                          color: AppColors.neutral_600,
                          height: 1.3)),
                ),
                _rowTile(
                  text: "Notes",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(widget.trip.notes,
                      maxLines: 3,
                      style: TextStyles.medium(
                          fontSize: 15,
                          color: AppColors.neutral_600,
                          height: 1.3)),
                ),
                const SizedBox(
                  height: 70,
                ),
              ]),
        ),
      ),
    );
  }

  Widget _iconTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neutral_300, size: 22),
          const SizedBox(
            width: 10,
          ),
          Text(text,
              maxLines: 3,
              style: TextStyles.regular(
                  color: AppColors.neutral_600, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _rowTile({required String text, double margin = 15}) {
    return Container(
      color: AppColors.neutral_30,
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: margin),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(text,
            maxLines: 3,
            style: TextStyles.bold(
              fontSize: 19,
              color: AppColors.neutral_500,
            )),
      ),
    );
  }
}

class _SliderImagesWidget extends StatefulWidget {
  const _SliderImagesWidget({Key? key, required this.imagesPaths})
      : super(key: key);
  final List<String> imagesPaths;

  @override
  State<_SliderImagesWidget> createState() => _SliderImagesWidgetState();
}

class _SliderImagesWidgetState extends State<_SliderImagesWidget> {
  int _pageIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
            items: widget.imagesPaths
                .map(
                  (image) => ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(8.0),
                    child: FadeInImage.assetNetwork(
                      image: image,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      placeholder: ' ',
                      placeholderErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.withOpacity(.3),
                        );
                      },
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 320,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(seconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              onPageChanged: (index, reason) {
                _pageIndex = index;
                setState(() {});
              },
              scrollDirection: Axis.horizontal,
            )),
        Positioned(bottom: 10, left: 0, right: 0, child: _progress()),
      ],
    );
  }

  Widget _progress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.imagesPaths.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _controller.animateToPage(entry.key),
          child: AnimatedContainer(
            width: _pageIndex == entry.key ? 30.0 : 10,
            height: 10.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.neutral_600, width: .1),
                borderRadius: BorderRadius.circular(10),
                color: _pageIndex == entry.key
                    ? AppColors.neutral_100
                    : AppColors.neutral_40),
            duration: const Duration(milliseconds: 300),
          ),
        );
      }).toList(),
    );
  }
}
