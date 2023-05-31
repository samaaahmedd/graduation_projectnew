import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'widgets/trip_details_preview_widget.dart';
import 'widgets/trip_header_widget.dart';

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
                TripHeaderRowWidget(text: widget.trip.title, margin: 0),
                TripDetailsPreviewWidget(
                  trip: widget.trip,
                ),
              ]),
        ),
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
                      placeholder: ImagesPaths.noImage,
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
              autoPlayInterval: const Duration(seconds: 2),
              autoPlayAnimationDuration: const Duration(seconds: 1),
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
        Positioned(
            left: 10,
            top: 10,
            child: IconButton(
                onPressed: () => pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))),
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
